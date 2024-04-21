# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents the sum of two nested expressions.
    class SumExpression
      def initialize(expression_a, expression_b)
        @expression_a = expression_a
        @expression_b = expression_b
      end

      def accept(visitor)
        visitor.visit_sum_expression(self)
      end

      attr_reader :expression_a, :expression_b
    end
  end
end
