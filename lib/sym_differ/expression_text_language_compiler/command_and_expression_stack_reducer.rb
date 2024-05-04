# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Evaluates the unevaluated expression tree (represented as a series of commands that return subexpressions) in the
    # provided stack by repeatedly evaluating the tail end of the stack and accumulating the results.
    class CommandAndExpressionStackReducer
      def initialize(highest_expression_precedence)
        @highest_expression_precedence = highest_expression_precedence
      end

      def reduce(command_and_expression_stack)
        precedence = @highest_expression_precedence

        command_and_expression_stack = shorten_stack_by_executing_unary_commands(command_and_expression_stack)

        while precedence >= 0
          command_and_expression_stack =
            shorten_stack_by_executing_commands_of_precedence(command_and_expression_stack, precedence)

          precedence -= 1
        end

        command_and_expression_stack
      end

      private

      def shorten_stack_by_executing_unary_commands(command_and_expression_stack)
        command_index = retrieve_next_unary_command_index(command_and_expression_stack)

        while stack_includes_command_of_given_precedence?(command_and_expression_stack, command_index)
          command_and_expression_stack = shorten_stack_by_executing_command(command_and_expression_stack, command_index)
          command_index = retrieve_next_unary_command_index(command_and_expression_stack)
        end

        command_and_expression_stack
      end

      def shorten_stack_by_executing_commands_of_precedence(command_and_expression_stack, precedence)
        command_index = retrieve_next_command_index(command_and_expression_stack, precedence)

        while stack_includes_command_of_given_precedence?(command_and_expression_stack, command_index)
          command_and_expression_stack = shorten_stack_by_executing_command(command_and_expression_stack, command_index)
          command_index = retrieve_next_command_index(command_and_expression_stack, precedence)
        end

        command_and_expression_stack
      end

      def retrieve_next_command_index(command_and_expression_stack, precedence)
        index = 0

        index += 1 until stack_has_command_item_followed_by_expression?(command_and_expression_stack, index, precedence)

        index
      end

      def retrieve_next_unary_command_index(command_and_expression_stack)
        index = 0

        index += 1 until stack_has_unary_command_item?(command_and_expression_stack, index)

        index
      end

      def stack_has_command_item_followed_by_expression?(command_and_expression_stack, index, precedence)
        stack_item = peek_item_in_stack(command_and_expression_stack, index)
        next_stack_item = peek_item_in_stack(command_and_expression_stack, index + 1)

        stack_item.nil? || (
          command_type_stack_item?(stack_item) &&
          stack_item_matches_precedence?(stack_item, precedence) &&
          !command_type_stack_item?(next_stack_item)
        )
      end

      def stack_has_unary_command_item?(command_and_expression_stack, index)
        previous_stack_item = peek_item_in_stack(command_and_expression_stack, index - 1)
        stack_item = peek_item_in_stack(command_and_expression_stack, index)
        next_stack_item = peek_item_in_stack(command_and_expression_stack, index + 1)

        stack_item.nil? || (
          !expression_type_stack_item?(previous_stack_item) &&
          command_type_stack_item?(stack_item) &&
          expression_type_stack_item?(next_stack_item)
        )
      end

      def stack_includes_command_of_given_precedence?(command_and_expression_stack, command_index)
        command_and_expression_stack[command_index] != nil
      end

      def shorten_stack_by_executing_command(command_and_expression_stack, command_index)
        earlier_argument, command, later_argument =
          extract_command_and_arguments_from_stack(command_and_expression_stack, command_index)

        executed_command_value = execute_stack_item_commands_and_arguments(command, earlier_argument, later_argument)

        earlier_stack_partition =
          extract_earlier_stack_partition(command_and_expression_stack, command_index, (earlier_argument ? 1 : 0))
        executed_command_stack_partition = build_stack_partition(build_expression_stack_item(executed_command_value))
        later_stack_partition = extract_later_stack_partition(command_and_expression_stack, command_index)

        combine_partitions_into_stack(earlier_stack_partition, executed_command_stack_partition, later_stack_partition)
      end

      def extract_command_and_arguments_from_stack(command_and_expression_stack, command_index)
        earlier_argument = peek_item_in_stack(command_and_expression_stack, command_index - 1)
        command = peek_item_in_stack(command_and_expression_stack, command_index)
        later_argument = peek_item_in_stack(command_and_expression_stack, command_index + 1)

        earlier_argument = (earlier_argument if expression_type_stack_item?(earlier_argument))

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

      def extract_later_stack_partition(stack, command_index)
        extract_stack_partition(stack, command_index + 2, stack.size)
      end

      def peek_item_in_stack(command_and_expression_stack, position)
        command_and_expression_stack[position] unless position.negative?
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

      def stack_item_matches_precedence?(stack_item, precedence)
        stack_item_precedence(stack_item) == precedence
      end

      def stack_item_precedence(stack_item)
        stack_item&.fetch(:precedence, nil)
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
