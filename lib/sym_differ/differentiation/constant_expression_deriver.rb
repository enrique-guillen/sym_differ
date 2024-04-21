# frozen_string_literal: true

module SymDiffer
  module Differentiation
    # Computes the expression that represents the derivative of a constant function.
    class ConstantExpressionDeriver
      def initialize(expression_factory)
        @expression_factory = expression_factory
      end

      def derive(_expression, _variable)
        build_constant_expression(0)
      end

      private

      def build_constant_expression(value)
        @expression_factory.create_constant_expression(value)
      end
    end
  end
end
