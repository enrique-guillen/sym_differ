# frozen_string_literal: true

require "sym_differ/expressions/expression"

module SymDiffer
  module Expressions
    # Represents an expression representing a fixed value.
    class ConstantExpression < Expression
      def initialize(value)
        @value = value
        super()
      end

      attr_reader :value

      def accept(visitor, *, &)
        visitor.visit_constant_expression(self, *, &)
      end

      def same_as?(other_expression)
        other_expression.is_a?(ConstantExpression) && value == other_expression.value
      end
    end
  end
end
