# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents an expression whose value is the negative value of the nested expression.
    class NegateExpression
      def initialize(negated_expression)
        @negated_expression = negated_expression
      end

      attr_reader :negated_expression

      def accept(visitor)
        visitor.visit_negate_expression(self)
      end
    end
  end
end