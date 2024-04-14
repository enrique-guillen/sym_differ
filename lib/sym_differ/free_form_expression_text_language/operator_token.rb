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
        if @symbol == "+"
          SumExpression.new(expression_a, expression_b)
        elsif @symbol == "-"
          if expression_a.nil?
            NegateExpression.new(expression_b)
          else
            SubtractExpression.new(expression_a, expression_b)
          end
        end
      end
    end
  end
end
