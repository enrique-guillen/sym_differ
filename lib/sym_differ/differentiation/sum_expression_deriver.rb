# frozen_string_literal: true

module SymDiffer
  module Differentiation
    # Computes the expresion that represents the derivative of the sum of two functions.
    class SumExpressionDeriver
      def initialize(deriver)
        @deriver = deriver
      end

      def derive(expression)
        SumExpression.new(
          expression.expression_a.accept(@deriver),
          expression.expression_b.accept(@deriver)
        )
      end
    end
  end
end
