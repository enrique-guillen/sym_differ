# frozen_string_literal: true

module SymDiffer
  module Differentiation
    # Computes the derivative of the provided expression in the form -subexpression.
    class NegateExpressionDeriver
      def initialize(differentiation_visitor, expression_factory)
        @differentiation_visitor = differentiation_visitor
        @expression_factory = expression_factory
      end

      def derive(expression)
        build_negate_expression(derive_expression(expression))
      end

      private

      def build_negate_expression(negated_expression)
        @expression_factory.create_negate_expression(negated_expression)
      end

      def derive_expression(expression)
        expression.negated_expression.accept(@differentiation_visitor)
      end
    end
  end
end
