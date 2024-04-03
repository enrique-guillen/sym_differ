# frozen_string_literal: true

require "sym_differ/free_form_expression_text_language/variable_token"
require "sym_differ/free_form_expression_text_language/constant_token"
require "sym_differ/free_form_expression_text_language/operator_token"

require "sym_differ/variable_expression"
require "sym_differ/constant_expression"
require "sym_differ/negate_expression"
require "sym_differ/sum_expression"

require "sym_differ/free_form_expression_text_language/invalid_syntax_error"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Takes a list of tokens appearing the expression in text form, and converts them into the corresponding Expression,
    # and returns a single Expression combining all of them.
    class ExpressionTreeBuilder
      def build(tokens)
        mode = :start_parsing
        expression = nil

        until no_elements_in_list?(tokens)
          mode, expression = analyze_current_token_in_list(mode, tokens[0], expression)
          tokens = take_list_tail(tokens)
        end

        validate_final_mode(mode)

        expression
      end

      private

      def no_elements_in_list?(list)
        list.empty?
      end

      def analyze_current_token_in_list(mode, token, previous_expression)
        try_evaluating_as_initial_mode(mode, token) ||
          try_evaluating_as_operator_or_end(mode, token, previous_expression) ||
          try_evaluating_as_sub_expression_for_incomplete_negation_expression(mode, token) ||
          try_evaluating_as_sub_expression_for_incomplete_sum_expression(mode, token, previous_expression)
      end

      def validate_final_mode(mode)
        raise_unparseable_expression_text_error(nil) unless mode == :allow_operator_or_end
      end

      def try_evaluating_as_initial_mode(mode, token)
        return unless mode == :start_parsing

        [next_mode_for_initial_token(token), build_expression_for_initial_token(token)]
      end

      def try_evaluating_as_operator_or_end(mode, token, previous_expression)
        return unless mode == :allow_operator_or_end

        [next_mode_for_post_sub_expression(token),
         build_expression_for_post_sub_expression_mode(token, previous_expression)]
      end

      def try_evaluating_as_sub_expression_for_incomplete_negation_expression(mode, token)
        return unless mode == :expecting_sub_expression_for_incomplete_negation_expression

        [next_mode_for_post_completing_negation_expression(token),
         build_expression_for_post_completing_negation_expression(token)]
      end

      def try_evaluating_as_sub_expression_for_incomplete_sum_expression(mode, token, previous_expression)
        return unless mode == :expecting_sub_expression_for_incomplete_sum_expression

        [next_mode_for_post_completing_sum_expression(token),
         build_expression_for_post_completing_sum_expression(token, previous_expression)]
      end

      def take_list_tail(list)
        list[1, list.size].to_a
      end

      def next_mode_for_initial_token(token)
        return :allow_operator_or_end if token.is_a?(VariableToken) || token.is_a?(ConstantToken)
        return unless token.is_a?(OperatorToken) && token.symbol == "-"

        :expecting_sub_expression_for_incomplete_negation_expression
      end

      def build_expression_for_initial_token(token)
        return build_variable_expression_from_token(token) if token.is_a?(VariableToken)
        return build_constant_expression_from_token(token) if token.is_a?(ConstantToken)
        return :negation_token if token.is_a?(OperatorToken) && token.symbol == "-"

        raise_unparseable_expression_text_error(token)
      end

      def next_mode_for_post_sub_expression(token)
        if token.is_a?(OperatorToken) && token.symbol == "+"
          return :expecting_sub_expression_for_incomplete_sum_expression
        end

        raise_unparseable_expression_text_error(token)
      end

      def build_expression_for_post_sub_expression_mode(token, expression)
        return expression if token.is_a?(OperatorToken) && token.symbol == "+"

        raise_unparseable_expression_text_error(token)
      end

      def next_mode_for_post_completing_negation_expression(token)
        return :allow_operator_or_end if token.is_a?(VariableToken) || token.is_a?(ConstantToken)

        raise_unparseable_expression_text_error(token)
      end

      def build_expression_for_post_completing_negation_expression(token)
        return build_negation_expression(build_variable_expression_from_token(token)) if token.is_a?(VariableToken)

        build_negation_expression(build_constant_expression_from_token(token)) if token.is_a?(ConstantToken)
      end

      def next_mode_for_post_completing_sum_expression(token)
        return :allow_operator_or_end if token.is_a?(VariableToken) || token.is_a?(ConstantToken)

        raise_unparseable_expression_text_error(token)
      end

      def build_expression_for_post_completing_sum_expression(token, expression)
        if token.is_a?(VariableToken)
          return build_sum_expression(expression, build_variable_expression_from_token(token))
        end

        if token.is_a?(ConstantToken)
          return build_sum_expression(expression, build_constant_expression_from_token(token))
        end

        raise_unparseable_expression_text_error(token)
      end

      def build_variable_expression_from_token(token)
        build_variable_expression(token.name)
      end

      def build_constant_expression_from_token(token)
        build_constant_expression(token.value)
      end

      def build_variable_expression(name)
        VariableExpression.new(name)
      end

      def build_constant_expression(value)
        ConstantExpression.new(value)
      end

      def build_negation_expression(negated_expression)
        NegateExpression.new(negated_expression)
      end

      def build_sum_expression(expression_a, expression_b)
        SumExpression.new(expression_a, expression_b)
      end

      def raise_unparseable_expression_text_error(token)
        raise InvalidSyntaxError.new("Expected a constant or variable, found #{token}", "")
      end
    end
  end
end
