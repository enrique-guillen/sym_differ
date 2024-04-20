# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/command_and_expression_stack_reducer"
require "sym_differ/expression_text_language_compiler/constant_token_checker"
require "sym_differ/expression_text_language_compiler/variable_token_checker"
require "sym_differ/expression_text_language_compiler/subtraction_token_checker"
require "sym_differ/expression_text_language_compiler/sum_token_checker"

module SymDiffer
  module ExpressionTextLanguageCompiler
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
        command_and_expression_stack_reducer.reduce(current_stack)
      end

      def get_checker_for_currently_expected_token_type(currently_expected_token_type)
        checkers_by_role[currently_expected_token_type]
      end

      def command_and_expression_stack_reducer
        @command_and_expression_stack_reducer ||= CommandAndExpressionStackReducer.new
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

      def last_item_in_stack(stack)
        stack.last
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
        @subtraction_token_checker ||= SubtractionTokenChecker.new(@expression_factory)
      end

      def stack_item_value(stack_item)
        stack_item&.[](:value)
      end
    end
  end
end
