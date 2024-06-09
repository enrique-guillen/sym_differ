# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/evaluation_stack"

require "sym_differ/expression_text_language_compiler/empty_tokens_list_error"
require "sym_differ/expression_text_language_compiler/invalid_token_terminated_expression_error"
require "sym_differ/expression_text_language_compiler/imbalanced_expression_error"
require "sym_differ/expression_text_language_compiler/expected_token_type_not_found_error"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Takes a list of tokens appearing the expression in text form, and converts them into the corresponding Expression,
    # and returns a single Expression combining all of them.
    class ExpressionTreeBuilder
      def initialize(evaluation_stack_reducer, itemifiers_by_role, invalid_expected_token_type_end_states)
        @evaluation_stack_reducer = evaluation_stack_reducer
        @itemifiers_by_role = itemifiers_by_role
        @invalid_expected_token_type_end_states = invalid_expected_token_type_end_states
      end

      def build(tokens)
        raise_empty_tokens_list_error if tokens.empty?
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
        evaluation_stack = EvaluationStack.new
        base_precedence_value = 0

        tokens.each do |t|
          evaluation_stack, expected_token_type, base_precedence_value =
            update_evaluation_stack_based_on_token(t, evaluation_stack, expected_token_type, base_precedence_value)
        end

        raise_invalid_token_termination_error if @invalid_expected_token_type_end_states.include?(expected_token_type)
        raise_imbalanced_expression_error unless base_precedence_value.zero?

        evaluation_stack
      end

      def update_evaluation_stack_based_on_token(token, evaluation_stack, expected_token_type, base_precedence_value)
        itemification = stack_itemify_token(token, expected_token_type)

        new_evaluation_stack =
          calculate_new_evaluation_stack_from_itemification(itemification, evaluation_stack, base_precedence_value)

        new_expected_token_type = access_stack_item_new_expected_token_type(itemification)

        new_base_precedence_value =
          calculate_new_base_precedence_value_from_itemification(itemification, base_precedence_value)

        [new_evaluation_stack, new_expected_token_type, new_base_precedence_value]
      end

      def calculate_new_evaluation_stack_from_itemification(itemification, evaluation_stack, base_precedence_value)
        return evaluation_stack if precedence_change_stack_item?(itemification[:stack_item])

        precedence = access_stack_item_precedence(itemification[:stack_item])
        current_precedence_value = base_precedence_value + precedence

        push_item_into_stack(
          reset_stack_item_precedence(itemification[:stack_item], current_precedence_value),
          evaluation_stack
        )
      end

      def calculate_new_base_precedence_value_from_itemification(itemification, base_precedence_value)
        return base_precedence_value unless precedence_change_stack_item?(itemification[:stack_item])

        new_precedence_change = acess_stack_item_new_precedence_change(itemification[:stack_item])

        base_precedence_value + new_precedence_change
      end

      def value_of_last_stack_item(evaluation_stack)
        stack_item_value(last_item_in_stack(evaluation_stack))
      end

      def stack_itemify_token(token, currently_expected_token_type)
        token_itemifiers_for_currently_expected_token_type =
          get_itemifiers_for_currently_expected_token_type(currently_expected_token_type)

        itemification = nil

        token_itemifiers_for_currently_expected_token_type.each do |itemifier|
          itemification = itemifier.check(token)

          break if itemification[:handled]
        end

        raise_expected_token_type_not_found_error unless itemification[:handled]

        itemification
      end

      def reduce_tail_end_of_stack_while_evaluatable(current_stack)
        @evaluation_stack_reducer.reduce(current_stack)
      end

      def get_itemifiers_for_currently_expected_token_type(currently_expected_token_type)
        @itemifiers_by_role[currently_expected_token_type]
      end

      def raise_invalid_token_termination_error
        raise InvalidTokenTerminatedExpressionError.new
      end

      def raise_imbalanced_expression_error
        raise ImbalancedExpressionError.new
      end

      def raise_empty_tokens_list_error
        raise EmptyTokensListError.new
      end

      def raise_expected_token_type_not_found_error
        raise ExpectedTokenTypeNotFoundError.new
      end

      def precedence_change_stack_item?(stack_item)
        access_stack_item_type(stack_item) == :precedence_change
      end

      def push_item_into_stack(item, stack)
        stack.add_item(item)
      end

      def last_item_in_stack(stack)
        stack.last_item
      end

      def access_stack_item_type(stack_item)
        stack_item[:item_type]
      end

      def access_stack_item_precedence(stack_item)
        stack_item[:precedence]
      end

      def acess_stack_item_new_precedence_change(stack_item)
        stack_item[:new_precedence_change]
      end

      def access_stack_item_new_expected_token_type(stack_item)
        stack_item[:next_expected_token_type]
      end

      def stack_item_value(stack_item)
        stack_item&.[](:value)
      end

      def reset_stack_item_precedence(stack_item, precedence_value)
        stack_item.merge(precedence: precedence_value)
      end
    end
  end
end
