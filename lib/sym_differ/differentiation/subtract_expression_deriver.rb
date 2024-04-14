# frozen_string_literal: true

require "sym_differ/subtract_expression"

module SymDiffer
  module Differentiation
    # Computes the expression that represents the derivative of a subtraction expression.
    class SubtractExpressionDeriver
      def initialize(differentiation_visitor)
        @differentiation_visitor = differentiation_visitor
      end

      def derive(expression)
        SubtractExpression.new(
          derive_expression(expression.minuend),
          derive_expression(expression.subtrahend)
        )
      end

      private

      def derive_expression(expression)
        expression.accept(@differentiation_visitor)
      end
    end
  end
end
