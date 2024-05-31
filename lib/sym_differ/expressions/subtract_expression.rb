# frozen_string_literal: true

require "sym_differ/expressions/expression"

module SymDiffer
  module Expressions
    # Represents the subtraction of two nested expressions.
    class SubtractExpression < Expression
      def initialize(minuend, subtrahend)
        @minuend = minuend
        @subtrahend = subtrahend
        super()
      end

      attr_reader :minuend, :subtrahend

      def accept(visitor, *, &)
        visitor.visit_subtract_expression(self, *, &)
      end

      def same_as?(other_expression)
        other_expression.is_a?(SubtractExpression) &&
          same_expressions?(minuend, other_expression.minuend) &&
          same_expressions?(subtrahend, other_expression.subtrahend)
      end

      private

      def same_expressions?(expression_1, expression_2)
        expression_1.same_as?(expression_2)
      end
    end
  end
end
