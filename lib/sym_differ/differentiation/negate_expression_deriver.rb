# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module Differentiation
    # Computes the derivative of the provided expression in the form -subexpression.
    class NegateExpressionDeriver
      extend Forwardable

      def initialize(differentiation_visitor, expression_factory)
        @differentiation_visitor = differentiation_visitor
        @expression_factory = expression_factory
      end

      def derive(expression)
        create_negate_expression(derive_expression(expression))
      end

      private

      def derive_expression(expression)
        expression.negated_expression.accept(@differentiation_visitor)
      end

      def_delegators :@expression_factory, :create_negate_expression
    end
  end
end
