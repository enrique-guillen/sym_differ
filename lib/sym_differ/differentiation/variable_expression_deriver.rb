# frozen_string_literal: true

require "sym_differ/constant_expression"

module SymDiffer
  module Differentiation
    # Computes the expresion that represents the derivative of an identity function.
    class VariableExpressionDeriver
      def initialize(expression_factory)
        @expression_factory = expression_factory
      end

      def derive(expression, variable)
        return build_constant_one if expression.name == variable

        build_constant_zero
      end

      private

      def build_constant_one
        build_constant_expression(1)
      end

      def build_constant_zero
        build_constant_expression(0)
      end

      def build_constant_expression(value)
        @expression_factory.create_constant_expression(value)
      end
    end
  end
end
