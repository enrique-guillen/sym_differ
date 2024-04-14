# frozen_string_literal: true

require "sym_differ/free_form_expression_text_language/variable_token"
require "sym_differ/free_form_expression_text_language/constant_token"
require "sym_differ/free_form_expression_text_language/operator_token"

require "sym_differ/free_form_expression_text_language/invalid_syntax_error"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Takes a list of tokens appearing the expression in text form, and converts them into the corresponding Expression,
    # and returns a single Expression combining all of them.
    class ExpressionTreeBuilder
      def build(tokens)
        build_expression_from_tokens(tokens)
      end

      private

      def build_expression_from_tokens(tokens)
        @next_expected_token_type = :valid_token_from_expression_start

        until no_elements_in_list?(tokens)
          analyze_current_token_in_list(take_list_head(tokens))
          tokens = take_list_tail(tokens)
        end

        validate_final_mode

        @buffered_expression
      end

      def no_elements_in_list?(list)
        list.empty?
      end

      def analyze_current_token_in_list(token)
        try_evaluating_as_initial_mode(token) ||
          try_evaluating_as_follow_up_to_leaf_token(token) ||
          try_evaluating_as_follow_up_to_negation_token(token) ||
          try_evaluating_as_follow_up_to_binary_operation_token(token)
      end

      def validate_final_mode
        raise_unparseable_expression_text_error unless @next_expected_token_type == :follow_up_to_leaf_token
      end

      def try_evaluating_as_initial_mode(token)
        return unless @next_expected_token_type == :valid_token_from_expression_start

        @buffered_binary_operation_token = token
        @buffered_expression = build_expression_for_initial_token(token)
        @next_expected_token_type = next_mode_for_initial_token(token)
      end

      def try_evaluating_as_follow_up_to_leaf_token(token)
        return unless @next_expected_token_type == :follow_up_to_leaf_token

        raise_invalid_syntax_error_unless_expression_is_operator(token)

        @buffered_binary_operation_token = token
        @next_expected_token_type = :follow_up_to_binary_operation_token
      end

      def try_evaluating_as_follow_up_to_negation_token(token)
        return unless @next_expected_token_type == :follow_up_to_negation_token

        raise_invalid_syntax_error_unless_expression_is_leaf_token(token)

        @buffered_expression = build_expression_for_post_completing_binary_expression(token)
        @next_expected_token_type = :follow_up_to_leaf_token
      end

      def try_evaluating_as_follow_up_to_binary_operation_token(token)
        return unless @next_expected_token_type == :follow_up_to_binary_operation_token

        raise_invalid_syntax_error_unless_expression_is_leaf_token(token)

        @buffered_expression = build_expression_for_post_completing_binary_expression(token)
        @next_expected_token_type = :follow_up_to_leaf_token
      end

      def take_list_head(list)
        list[0]
      end

      def take_list_tail(list)
        list[1, list.size].to_a
      end

      def next_mode_for_initial_token(token)
        return :follow_up_to_leaf_token if token.is_a?(VariableToken) || token.is_a?(ConstantToken)
        return unless token.is_a?(OperatorToken) && token.symbol == "-"

        :follow_up_to_negation_token
      end

      def build_expression_for_initial_token(token)
        return token.transform_into_expression if token.is_a?(VariableToken) || token.is_a?(ConstantToken)
        return if token.is_a?(OperatorToken) && token.symbol == "-"

        raise_unparseable_expression_text_error
      end

      def raise_invalid_syntax_error_unless_expression_is_operator(token)
        raise_unparseable_expression_text_error unless token.is_a?(OperatorToken)
      end

      def raise_invalid_syntax_error_unless_expression_is_leaf_token(token)
        raise_unparseable_expression_text_error unless token.is_a?(VariableToken) || token.is_a?(ConstantToken)
      end

      def build_expression_for_post_completing_binary_expression(token)
        @buffered_binary_operation_token.transform_into_expression(
          @buffered_expression, token.transform_into_expression
        )
      end

      def raise_unparseable_expression_text_error
        raise InvalidSyntaxError.new("")
      end
    end
  end
end
