# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents an expression representing the multiplication of the two sub expressions.
    class MultiplicateExpression
      def initialize(multiplicand, multiplier)
        @multiplicand = multiplicand
        @multiplier = multiplier
      end

      attr_reader :multiplicand, :multiplier

      def accept(visitor)
        visitor.visit_multiplicate_expression(self)
      end

      def same_as?(other_expression)
        other_expression.is_a?(MultiplicateExpression) &&
          same_expressions?(multiplicand, other_expression.multiplicand) &&
          same_expressions?(multiplier, other_expression.multiplier)
      end

      private

      def same_expressions?(expression_1, expression_2)
        expression_1.same_as?(expression_2)
      end
    end
  end
end
