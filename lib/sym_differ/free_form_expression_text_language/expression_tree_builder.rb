# frozen_string_literal: true

require "sym_differ/free_form_expression_text_language/constant_token_checker"
require "sym_differ/free_form_expression_text_language/variable_token_checker"
require "sym_differ/free_form_expression_text_language/subtraction_token_checker"
require "sym_differ/free_form_expression_text_language/sum_token_checker"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Takes a list of tokens appearing the expression in text form, and converts them into the corresponding Expression,
    # and returns a single Expression combining all of them.
    class ExpressionTreeBuilder
      def build(tokens)
        raise_invalid_syntax_error if tokens.empty?
        convert_tokens_into_expression(tokens)
      end

      private

      def convert_tokens_into_expression(tokens)
        currently_expected_token_type = :prefix_token_checkers
        command_and_expression_stack = []

        tokens.each do |token|
          command_and_expression_stack, currently_expected_token_type =
            update_command_and_expression_stack_based_on_token(
              token, command_and_expression_stack, currently_expected_token_type
            )
        end

        raise_invalid_syntax_error if multiple_commands_or_expressions_left_in_stack?(command_and_expression_stack)
        stack_item_value(last_item_in_stack(command_and_expression_stack))
      end

      def update_command_and_expression_stack_based_on_token(token,
                                                             command_and_expression_stack,
                                                             currently_expected_token_type)
        stack_item_for_token = check_stack_item_corresponding_to_token(token, currently_expected_token_type)

        raise_invalid_syntax_error unless stack_item_for_token[:handled]

        command_and_expression_stack =
          push_item_into_stack(stack_item_for_token[:stack_item], command_and_expression_stack)

        if stack_item_for_token[:expression_location] == :rightmost
          command_and_expression_stack = reduce_tail_end_of_stack_while_evaluatable(command_and_expression_stack)
        end

        currently_expected_token_type =
          stack_item_for_token[:expression_location] == :rightmost ? :infix_token_checkers : :prefix_token_checkers

        [command_and_expression_stack, currently_expected_token_type]
      end

      def check_stack_item_corresponding_to_token(token, currently_expected_token_type)
        result_of_checking_stack_item_type = nil

        get_checker_for_currently_expected_token_type(currently_expected_token_type).each do |checker|
          result_of_checking_stack_item_type = checker.check(token)
          break if result_of_checking_stack_item_type[:handled]
        end

        result_of_checking_stack_item_type
      end

      def reduce_tail_end_of_stack_while_evaluatable(current_stack)
        while stack_item_is_command_type?(penultimate_item_in_stack(current_stack))
          current_stack = apply_command_to_arguments_at_tail_end_of_stack(current_stack)
        end

        current_stack
      end

      def get_checker_for_currently_expected_token_type(currently_expected_token_type)
        checkers_by_role[currently_expected_token_type]
      end

      def apply_command_to_arguments_at_tail_end_of_stack(current_stack)
        last_argument_stack_item, command_stack_item, previous_argument_stack_item =
          extract_command_and_arguments_from_tail_end_of_stack(current_stack)

        value_of_executing_command = execute_stack_item_commands_and_arguments(
          command_stack_item, previous_argument_stack_item, last_argument_stack_item
        )

        stack_minus_evaluated_items = drop_last_items_of_stack(current_stack, previous_argument_stack_item ? 3 : 2)

        push_item_into_stack(
          build_expression_type_stack_item(value_of_executing_command),
          stack_minus_evaluated_items
        )
      end

      def extract_command_and_arguments_from_tail_end_of_stack(current_stack)
        tail_end = read_last_items_of_stack_backwards(current_stack, 3)
        last_argument_stack_item = tail_end[0]
        command_stack_item = tail_end[1]
        previous_argument_stack_item = (tail_end[2] if stack_item_is_expression_type?(tail_end[2]))

        [last_argument_stack_item, command_stack_item, previous_argument_stack_item]
      end

      def execute_stack_item_commands_and_arguments(command_stack_item,
                                                    previous_argument_stack_item,
                                                    last_argument_stack_item)
        execute_command(
          stack_item_value(command_stack_item),
          [stack_item_value(previous_argument_stack_item), stack_item_value(last_argument_stack_item)].compact
        )
      end

      def checkers_by_role
        @checkers_by_role ||= {
          prefix_token_checkers: [constant_token_checker, variable_token_checker, subtraction_token_checker],
          infix_token_checkers: [sum_token_checker, subtraction_token_checker]
        }.freeze
      end

      def raise_invalid_syntax_error
        raise InvalidSyntaxError.new("")
      end

      def push_item_into_stack(item, stack)
        stack + [item]
      end

      def penultimate_item_in_stack(command_and_expression_stack)
        size = command_and_expression_stack.size
        return nil if size <= 0

        command_and_expression_stack[size - 2]
      end

      def last_item_in_stack(stack)
        stack.last
      end

      def read_last_items_of_stack_backwards(stack, amount)
        stack.last(amount).reverse
      end

      def drop_last_items_of_stack(stack, amount)
        stack[0, stack.size - amount]
      end

      def multiple_commands_or_expressions_left_in_stack?(stack)
        stack.size > 1
      end

      def constant_token_checker
        @constant_token_checker ||= ConstantTokenChecker.new
      end

      def variable_token_checker
        @variable_token_checker ||= VariableTokenChecker.new
      end

      def sum_token_checker
        @sum_token_checker ||= SumTokenChecker.new
      end

      def subtraction_token_checker
        @subtraction_token_checker ||= SubtractionTokenChecker.new
      end

      def build_expression_type_stack_item(expression)
        build_stack_item(:expression, expression)
      end

      def stack_item_is_expression_type?(stack_item)
        stack_item_item_type(stack_item) == :expression
      end

      def stack_item_is_command_type?(stack_item)
        stack_item_item_type(stack_item) == :pending_command
      end

      def build_stack_item(item_type, value)
        { item_type:, value: }
      end

      def stack_item_item_type(stack_item)
        stack_item&.[](:item_type)
      end

      def stack_item_value(stack_item)
        stack_item&.[](:value)
      end

      def execute_command(command, arguments = [])
        command.execute(arguments)
      end
    end
  end
end
