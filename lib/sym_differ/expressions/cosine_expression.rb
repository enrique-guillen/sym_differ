# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents an expression representing the trigonometrical Cosine function applied to the nested angle expression.
    class CosineExpression
      def initialize(angle_expression)
        @angle_expression = angle_expression
      end

      attr_reader :angle_expression

      def accept(visitor)
        visitor.visit_cosine_expression(self)
      end

      def same_as?(other_expression)
        other_expression.is_a?(CosineExpression) &&
          angle_expression.same_as?(other_expression.angle_expression)
      end
    end
  end
end
