# frozen_string_literal: true

require "sym_differ/sum_expression"
require "sym_differ/negate_expression"
require "sym_differ/subtract_expression"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Token representing an infix operator appearing in an expression text.
    class OperatorToken
      def initialize(symbol)
        @symbol = symbol
      end

      attr_reader :symbol

      def transform_into_expression(expression_a, expression_b)
        return build_sum_expression(expression_a, expression_b) if symbol_is_plus_sign?

        if symbol_is_dash? && expression_a.nil?
          build_negate_expression(expression_b)
        elsif symbol_is_dash?
          build_subtract_expression(expression_a, expression_b)
        end
      end

      private

      def symbol_is_plus_sign?
        @symbol == "+"
      end

      def symbol_is_dash?
        @symbol == "-"
      end

      def build_sum_expression(expression_a, expression_b)
        SumExpression.new(expression_a, expression_b)
      end

      def build_negate_expression(expression)
        NegateExpression.new(expression)
      end

      def build_subtract_expression(expression_a, expression_b)
        SubtractExpression.new(expression_a, expression_b)
      end
    end
  end
end
