# frozen_string_literal: true

require "sym_differ/constant_expression"

module SymDiffer
  module Differentiation
    # Computes the expresion that represents the derivative of an identity function.
    class VariableExpressionDeriver
      def derive(expression, variable)
        return ConstantExpression.new(1) if expression.name == variable

        ConstantExpression.new(0)
      end
    end
  end
end
