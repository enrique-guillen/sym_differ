# frozen_string_literal: true

module SymDiffer
  module Differentiation
    # Computes the expresion that represents the derivative of the sum of two functions.
    class SumExpressionDeriver
      def initialize(deriver, expression_factory)
        @deriver = deriver
        @expression_factory = expression_factory
      end

      def derive(expression)
        build_sum_expression(
          derive_expression(expression.expression_a),
          derive_expression(expression.expression_b)
        )
      end

      private

      def build_sum_expression(expression_a, expression_b)
        @expression_factory.create_sum_expression(
          expression_a,
          expression_b
        )
      end

      def derive_expression(expression)
        expression.accept(@deriver)
      end
    end
  end
end
