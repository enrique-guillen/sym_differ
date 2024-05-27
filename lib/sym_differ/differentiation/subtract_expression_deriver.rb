# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module Differentiation
    # Computes the expression that represents the derivative of a subtraction expression.
    class SubtractExpressionDeriver
      extend Forwardable

      def initialize(differentiation_visitor, expression_factory)
        @differentiation_visitor = differentiation_visitor
        @expression_factory = expression_factory
      end

      def derive(expression)
        create_subtract_expression(
          derive_expression(expression.minuend),
          derive_expression(expression.subtrahend)
        )
      end

      private

      def derive_expression(expression)
        expression.accept(@differentiation_visitor)
      end

      def_delegators :@expression_factory, :create_subtract_expression
    end
  end
end
