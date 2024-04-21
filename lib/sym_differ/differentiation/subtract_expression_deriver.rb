# frozen_string_literal: true

require "sym_differ/subtract_expression"

module SymDiffer
  module Differentiation
    # Computes the expression that represents the derivative of a subtraction expression.
    class SubtractExpressionDeriver
      def initialize(differentiation_visitor, expression_factory)
        @differentiation_visitor = differentiation_visitor
        @expression_factory = expression_factory
      end

      def derive(expression)
        build_subtract_expression(
          derive_expression(expression.minuend),
          derive_expression(expression.subtrahend)
        )
      end

      private

      def build_subtract_expression(minuend, subtrahend)
        @expression_factory.create_subtract_expression(minuend, subtrahend)
      end

      def derive_expression(expression)
        expression.accept(@differentiation_visitor)
      end
    end
  end
end
