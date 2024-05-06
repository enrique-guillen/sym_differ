# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Evaluates the unevaluated expression tree (represented as a series of commands that return subexpressions) in the
    # provided stack by repeatedly evaluating the tail end of the stack and accumulating the results.
    class CommandAndExpressionStackReducer
      def reduce(evalution_stack, precedence = nil)
        precedence ||=
          evalution_stack.map { |stack_item| stack_item_precedence(stack_item) }.max

        shorten_stack_by_executing_commands_of_precedence(evalution_stack, precedence)
      end

      private

      def shorten_stack_by_executing_commands_of_precedence(evalution_stack, precedence)
        command_index = retrieve_next_executable_command_index_of_precedence(evalution_stack, precedence)

        return evalution_stack if no_command_in_stack_at_index?(evalution_stack, command_index) && precedence <= 0
        return reduce(evalution_stack, precedence - 1) if no_command_in_stack_at_index?(evalution_stack, command_index)

        new_evaluation_stack = reduce_tail_end_of_stack_if_unary(evalution_stack, command_index, precedence)
        new_evaluation_stack = shorten_stack_by_executing_command(new_evaluation_stack, command_index)
        new_evaluation_stack = reduce(new_evaluation_stack, precedence)

        reduce(new_evaluation_stack, precedence - 1)
      end

      def retrieve_next_executable_command_index_of_precedence(evalution_stack, precedence)
        index = 0

        index += 1 until stack_at_index_is_executable_command_or_end?(evalution_stack, index, precedence)

        index
      end

      def reduce_tail_end_of_stack_if_unary(evalution_stack, command_index, precedence)
        current_item_in_stack = peek_item_in_stack(evalution_stack, command_index)
        next_item_in_stack = peek_item_in_stack(evalution_stack, command_index + 1)

        is_next_item_in_stack_unary_command = command_type_stack_item?(next_item_in_stack) &&
                                              non_zero_arity_minimum_command_stack_item?(current_item_in_stack) &&
                                              non_zero_arity_minimum_command_stack_item?(next_item_in_stack)

        return evalution_stack unless is_next_item_in_stack_unary_command

        earlier_stack_partition = extract_stack_beginning_partition(evalution_stack, command_index + 1)
        next_stack_partition = extract_stack_tail_end_partition(evalution_stack, command_index + 1)

        reduced_next_one = reduce(next_stack_partition, precedence)

        earlier_stack_partition + reduced_next_one
      end

      def stack_at_index_is_executable_command_or_end?(evalution_stack, index, precedence)
        stack_item = peek_item_in_stack(evalution_stack, index)
        next_stack_item = peek_item_in_stack(evalution_stack, index + 1)

        stack_item.nil? || (
          command_type_stack_item?(stack_item) &&
          stack_item_matches_precedence?(stack_item, precedence) &&
          (!command_type_stack_item?(next_stack_item) || stack_item_precedence(next_stack_item) < precedence)
        )
      end

      def no_command_in_stack_at_index?(evalution_stack, command_index)
        evalution_stack[command_index].nil?
      end

      def shorten_stack_by_executing_command(evalution_stack, command_index)
        earlier_argument, command, later_argument =
          extract_command_and_arguments_from_stack(evalution_stack, command_index)

        executed_command_value = execute_stack_item_commands_and_arguments(command, earlier_argument, later_argument)

        earlier_stack_partition =
          extract_earlier_stack_partition(evalution_stack, command_index, (earlier_argument ? 1 : 0))

        executed_command_stack_partition = build_stack_partition(build_expression_stack_item(executed_command_value))

        later_stack_partition =
          extract_later_stack_partition(evalution_stack, command_index, (later_argument ? 1 : 0))

        combine_partitions_into_stack(earlier_stack_partition, executed_command_stack_partition, later_stack_partition)
      end

      def extract_command_and_arguments_from_stack(evalution_stack, command_index)
        earlier_argument = peek_item_in_stack(evalution_stack, command_index - 1)
        command = peek_item_in_stack(evalution_stack, command_index)
        later_argument = peek_item_in_stack(evalution_stack, command_index + 1)

        earlier_argument = (
          earlier_argument if expression_type_stack_item?(earlier_argument) &&
                              stack_item_max_argument_amount(command) > 1
        )

        later_argument = (later_argument if expression_type_stack_item?(later_argument))

        [earlier_argument, command, later_argument]
      end

      def execute_stack_item_commands_and_arguments(command, previous_argument, last_argument)
        execute_command(
          stack_item_value(command),
          [stack_item_value(previous_argument), stack_item_value(last_argument)].compact
        )
      end

      def extract_earlier_stack_partition(stack, command_index, pre_command_argument_amount)
        extract_stack_partition(stack, 0, command_index - pre_command_argument_amount)
      end

      def extract_later_stack_partition(stack, command_index, post_command_argument_amount)
        extract_stack_partition(stack, command_index + 1 + post_command_argument_amount, stack.size)
      end

      def peek_item_in_stack(evalution_stack, position)
        evalution_stack[position] unless position.negative?
      end

      def extract_stack_beginning_partition(stack, number_of_elements)
        stack[0, number_of_elements].to_a
      end

      def extract_stack_tail_end_partition(stack, starting_index)
        stack[starting_index, stack.size].to_a
      end

      def extract_stack_partition(stack, starting_index, number_of_elements)
        stack[starting_index, number_of_elements].to_a
      end

      def build_stack_partition(*stack_items)
        [*stack_items]
      end

      def combine_partitions_into_stack(*stack_partitions)
        stack_partitions.sum([])
      end

      def execute_command(command, arguments)
        command.execute(arguments)
      end

      def non_zero_arity_minimum_command_stack_item?(stack_item)
        stack_item_min_argument_amount(stack_item).positive?
      end

      def stack_item_matches_precedence?(stack_item, precedence)
        stack_item_precedence(stack_item) == precedence
      end

      def stack_item_precedence(stack_item)
        stack_item&.fetch(:precedence, nil)
      end

      def stack_item_max_argument_amount(stack_item)
        stack_item&.fetch(:max_argument_amount, nil)
      end

      def stack_item_min_argument_amount(stack_item)
        stack_item&.fetch(:min_argument_amount, nil)
      end

      def command_type_stack_item?(stack_item)
        stack_item&.fetch(:item_type, nil) == :pending_command
      end

      def expression_type_stack_item?(stack_item)
        stack_item&.fetch(:item_type, nil) == :expression
      end

      def stack_item_value(stack_item)
        stack_item&.fetch(:value, nil)
      end

      def build_expression_stack_item(expression)
        build_stack_item(:expression, expression)
      end

      def build_stack_item(item_type, value, precedence = 0)
        { item_type:, value:, precedence: }
      end
    end
  end
end
