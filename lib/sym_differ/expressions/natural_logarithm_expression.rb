# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents the logarithm with base=special Euler number, applied to the nested power expression.
    class NaturalLogarithmExpression
      def initialize(power)
        @power = power
      end

      attr_reader :power

      def accept(visitor, *, &)
        visitor.visit_natural_logarithm_expression(self, *, &)
      end

      def same_as?(other_expression)
        other_expression.is_a?(NaturalLogarithmExpression) && other_expression.power.same_as?(power)
      end
    end
  end
end
