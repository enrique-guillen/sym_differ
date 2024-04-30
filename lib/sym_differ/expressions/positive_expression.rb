# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents an expression whose value is the nested expression (summand).
    class PositiveExpression
      def initialize(summand)
        @summand = summand
      end

      attr_reader :summand

      def accept(visitor)
        visitor.visit_positive_expression(self)
      end

      def same_as?(other_expression)
        other_expression.is_a?(PositiveExpression) && summand.same_as?(other_expression.summand)
      end
    end
  end
end
