# frozen_string_literal: true

require "sym_differ/negate_expression"

module SymDiffer
  module Differentiation
    # Computes the derivative of the provided expression in the form -subexpression.
    class NegateExpressionDeriver
      def initialize(differentiation_visitor)
        @differentiation_visitor = differentiation_visitor
      end

      def derive(expression)
        build_negate_expression(derive_expression(expression))
      end

      private

      def build_negate_expression(negated_expression)
        NegateExpression.new(negated_expression)
      end

      def derive_expression(expression)
        expression.negated_expression.accept(@differentiation_visitor)
      end
    end
  end
end
