# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents an expression raising the provided base to the given power.
    class ExponentiateExpression
      def initialize(base, power)
        @base = base
        @power = power
      end

      attr_reader :base, :power

      def accept(visitor)
        visitor.visit_exponentiate_expression(self)
      end

      def same_as?(other_expression)
        other_expression.is_a?(ExponentiateExpression) &&
          base.same_as?(other_expression.base) &&
          power.same_as?(other_expression.power)
      end
    end
  end
end
