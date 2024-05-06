# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/invalid_syntax_error"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Takes a list of tokens appearing the expression in text form, and converts them into the corresponding Expression,
    # and returns a single Expression combining all of them.
    class ExpressionTreeBuilder
      def initialize(evaluation_stack_reducer, checkers_by_role, invalid_expected_token_type_end_states)
        @evaluation_stack_reducer = evaluation_stack_reducer
        @checkers_by_role = checkers_by_role
        @invalid_expected_token_type_end_states = invalid_expected_token_type_end_states
      end

      def build(tokens)
        raise_invalid_syntax_error if tokens.empty?
        convert_tokens_into_expression(tokens)
      end

      private

      def convert_tokens_into_expression(tokens)
        evaluation_stack = calculate_evaluation_stack(tokens)

        evaluation_stack = reduce_tail_end_of_stack_while_evaluatable(evaluation_stack)

        value_of_last_stack_item(evaluation_stack)
      end

      def calculate_evaluation_stack(tokens)
        expected_token_type = :initial_token_checkers
        evaluation_stack = []
        base_precedence_value = 0

        tokens.each do |t|
          evaluation_stack, expected_token_type, base_precedence_value =
            update_evaluation_stack_based_on_token(t, evaluation_stack, expected_token_type, base_precedence_value)
        end

        raise_invalid_syntax_error if @invalid_expected_token_type_end_states.include?(expected_token_type)
        raise_invalid_syntax_error unless base_precedence_value.zero?

        evaluation_stack
      end

      def update_evaluation_stack_based_on_token(token, evaluation_stack, expected_token_type, base_precedence_value)
        stack_item_for_token = check_token_stack_item(token, expected_token_type)

        new_evaluation_stack =
          calculate_new_evaluation_stack_from_stack_item(stack_item_for_token, evaluation_stack, base_precedence_value)

        new_expected_token_type = calculate_new_expected_token_type_from_stack_item(stack_item_for_token)

        new_base_precedence_value =
          calculate_new_base_precedence_value_from_stack_item(stack_item_for_token, base_precedence_value)

        [new_evaluation_stack, new_expected_token_type, new_base_precedence_value]
      end

      def calculate_new_evaluation_stack_from_stack_item(stack_item, evaluation_stack, base_precedence_value)
        return evaluation_stack if stack_item[:stack_item][:item_type] == :precedence_change

        current_precedence_value = base_precedence_value + stack_item[:stack_item][:precedence]

        push_item_into_stack(stack_item[:stack_item].merge(precedence: current_precedence_value), evaluation_stack)
      end

      def calculate_new_expected_token_type_from_stack_item(stack_item)
        stack_item[:next_expected_token_type]
      end

      def calculate_new_base_precedence_value_from_stack_item(stack_item, base_precedence_value)
        if stack_item[:stack_item][:item_type] == :precedence_change
          base_precedence_value + stack_item[:stack_item][:new_precedence_change]
        else
          base_precedence_value
        end
      end

      def value_of_last_stack_item(evaluation_stack)
        stack_item_value(last_item_in_stack(evaluation_stack))
      end

      def check_token_stack_item(token, currently_expected_token_type)
        token_checkers_for_currently_expected_token_type =
          get_checkers_for_currently_expected_token_type(currently_expected_token_type)

        result_of_checking_stack_item_type = nil

        token_checkers_for_currently_expected_token_type.each do |checker|
          result_of_checking_stack_item_type = checker.check(token)

          break if result_of_checking_stack_item_type[:handled]
        end

        raise_invalid_syntax_error unless result_of_checking_stack_item_type[:handled]

        result_of_checking_stack_item_type
      end

      def reduce_tail_end_of_stack_while_evaluatable(current_stack)
        @evaluation_stack_reducer.reduce(current_stack)
      end

      def get_checkers_for_currently_expected_token_type(currently_expected_token_type)
        @checkers_by_role[currently_expected_token_type]
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

      def stack_item_value(stack_item)
        stack_item&.[](:value)
      end
    end
  end
end
