# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module Differentiation
    # Computes the expresion that represents the derivative of the sum of two functions.
    class SumExpressionDeriver
      extend Forwardable

      def initialize(deriver, expression_factory)
        @deriver = deriver
        @expression_factory = expression_factory
      end

      def derive(expression)
        create_sum_expression(
          derive_expression(expression.expression_a),
          derive_expression(expression.expression_b)
        )
      end

      private

      def derive_expression(expression)
        expression.accept(@deriver)
      end

      def_delegators :@expression_factory, :create_sum_expression
    end
  end
end
