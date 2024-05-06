# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents a not-yet-evaluated derivative of an expression.
    class DerivativeExpression
      def initialize(underived_expression, variable)
        @underived_expression = underived_expression
        @variable = variable
      end

      attr_reader :underived_expression, :variable

      def same_as?(other_expression)
        other_expression.is_a?(DerivativeExpression) &&
          other_expression.underived_expression.same_as?(underived_expression) &&
          other_expression.variable.same_as?(variable)
      end
    end
  end
end
