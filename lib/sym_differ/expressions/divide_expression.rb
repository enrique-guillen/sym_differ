# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents an expression dividing the given numerator by the given denominator.
    class DivideExpression
      def initialize(numerator, denominator)
        @numerator = numerator
        @denominator = denominator
      end

      attr_reader :numerator, :denominator

      def accept(visitor)
        visitor.visit_divide_expression(self)
      end

      def same_as?(other_expression)
        other_expression.is_a?(DivideExpression) &&
          numerator.same_as?(other_expression.numerator) &&
          denominator.same_as?(other_expression.denominator)
      end
    end
  end
end
