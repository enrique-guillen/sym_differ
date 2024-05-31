# frozen_string_literal: true

require "sym_differ/expressions/expression"

module SymDiffer
  module Expressions
    # Represents an expression whose value is the negative value of the nested expression.
    class NegateExpression < Expression
      def initialize(negated_expression)
        @negated_expression = negated_expression
        super()
      end

      attr_reader :negated_expression

      def accept(visitor, *, &)
        visitor.visit_negate_expression(self, *, &)
      end

      def same_as?(other_expression)
        other_expression.is_a?(NegateExpression) &&
          negated_expression.same_as?(other_expression.negated_expression)
      end
    end
  end
end
