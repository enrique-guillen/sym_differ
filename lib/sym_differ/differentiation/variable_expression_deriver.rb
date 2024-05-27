# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module Differentiation
    # Computes the expresion that represents the derivative of an identity function.
    class VariableExpressionDeriver
      extend Forwardable

      def initialize(expression_factory)
        @expression_factory = expression_factory
      end

      def derive(expression, variable)
        return build_constant_one if expression.name == variable

        build_constant_zero
      end

      private

      def build_constant_one
        create_constant_expression(1)
      end

      def build_constant_zero
        create_constant_expression(0)
      end

      def_delegators :@expression_factory, :create_constant_expression
    end
  end
end
