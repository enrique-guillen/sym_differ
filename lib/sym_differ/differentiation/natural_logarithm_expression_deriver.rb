# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module Differentiation
    # Computes the expression that represents the natural logarithm of a power expression.
    class NaturalLogarithmExpressionDeriver
      extend Forwardable

      def initialize(expression_factory, differentiation_visitor)
        @expression_factory = expression_factory
        @differentiation_visitor = differentiation_visitor
      end

      def derive(expression)
        create_divide_expression(
          derive_expression(expression.power),
          expression.power
        )
      end

      private

      def derive_expression(expression)
        expression.accept(@differentiation_visitor)
      end

      def_delegator :@expression_factory, :create_divide_expression
    end
  end
end
