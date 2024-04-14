# frozen_string_literal: true

require "sym_differ/sum_expression"

module SymDiffer
  module Differentiation
    # Computes the expresion that represents the derivative of the sum of two functions.
    class SumExpressionDeriver
      def initialize(deriver)
        @deriver = deriver
      end

      def derive(expression)
        SumExpression.new(
          derive_expression(expression.expression_a),
          derive_expression(expression.expression_b)
        )
      end

      private

      def derive_expression(expression)
        expression.accept(@deriver)
      end
    end
  end
end
