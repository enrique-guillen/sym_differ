# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents the sum of two nested expressions.
    class SumExpression
      def initialize(expression_a, expression_b)
        @expression_a = expression_a
        @expression_b = expression_b
      end

      attr_reader :expression_a, :expression_b

      def accept(visitor)
        visitor.visit_sum_expression(self)
      end

      def same_as?(other_expression)
        other_expression.is_a?(SumExpression) &&
          same_expressions?(expression_a, other_expression.expression_a) &&
          same_expressions?(expression_b, other_expression.expression_b)
      end

      private

      def same_expressions?(expression_1, expression_2)
        expression_1.same_as?(expression_2)
      end
    end
  end
end
