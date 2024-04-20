# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Evaluates the unevaluated expression tree (represented as a series of commands that return subexpressions) in the
    # provided stack by repeatedly evaluating the tail end of the stack and accumulating the results.
    class CommandAndExpressionStackReducer
      def reduce(command_and_expression_stack)
        while penultimate_item_in_stack_is_command_type?(command_and_expression_stack)
          command_and_expression_stack =
            shorten_tail_end_of_stack_by_executing_pending_command(command_and_expression_stack)
        end

        command_and_expression_stack
      end

      private

      def penultimate_item_in_stack_is_command_type?(command_and_expression_stack)
        command_stack_item = peek_item_from_end_of_stack(command_and_expression_stack, 1)

        command_type_stack_item?(command_stack_item)
      end

      def shorten_tail_end_of_stack_by_executing_pending_command(command_and_expression_stack)
        last_argument, command, earlier_argument =
          extract_command_and_arguments_from_tail_end_of_stack(command_and_expression_stack)

        executed_command_value =
          execute_stack_item_commands_and_arguments(command, earlier_argument, last_argument)

        stack_without_evaluated_tail_end =
          drop_items_from_stack_tail_end(command_and_expression_stack, earlier_argument.nil? ? 2 : 3)

        add_item_to_stack_tail_end(stack_without_evaluated_tail_end,
                                   build_expression_stack_item(executed_command_value))
      end

      def extract_command_and_arguments_from_tail_end_of_stack(command_and_expression_stack)
        last_argument = peek_item_from_end_of_stack(command_and_expression_stack, 0)
        command = peek_item_from_end_of_stack(command_and_expression_stack, 1)
        earlier_argument = peek_item_from_end_of_stack(command_and_expression_stack, 2)

        earlier_argument = (earlier_argument if expression_type_stack_item?(earlier_argument))

        [last_argument, command, earlier_argument]
      end

      def execute_stack_item_commands_and_arguments(command_stack_item,
                                                    previous_argument_stack_item,
                                                    last_argument_stack_item)
        execute_command(
          stack_item_value(command_stack_item),
          [stack_item_value(previous_argument_stack_item), stack_item_value(last_argument_stack_item)].compact
        )
      end

      def peek_item_from_end_of_stack(command_and_expression_stack, position_starting_from_end)
        size = command_and_expression_stack.size
        return unless size > position_starting_from_end

        command_and_expression_stack[size - position_starting_from_end - 1]
      end

      def drop_items_from_stack_tail_end(stack, amount_to_drop)
        stack[0, stack.size - amount_to_drop].to_a
      end

      def add_item_to_stack_tail_end(stack, item)
        stack + [item]
      end

      def execute_command(command, arguments)
        command.execute(arguments)
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

      def build_stack_item(item_type, value)
        { item_type:, value: }
      end
    end
  end
end
