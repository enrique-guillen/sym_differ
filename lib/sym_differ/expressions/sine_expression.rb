# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents an expression representing the trigonometrical Sine function applied to the nested angle expression.
    class SineExpression
      def initialize(angle_expression)
        @angle_expression = angle_expression
      end

      attr_reader :angle_expression

      def accept(visitor)
        visitor.visit_sine_expression(self)
      end

      def same_as?(other_expression)
        other_expression.is_a?(SineExpression) &&
          angle_expression.same_as?(other_expression.angle_expression)
      end
    end
  end
end
