# frozen_string_literal: true

require "sym_differ/constant_expression"

module SymDiffer
  module Differentiation
    # Computes the expression that represents the derivative of a constant function.
    class ConstantExpressionDeriver
      def derive(_expression, _variable)
        ConstantExpression.new(0)
      end
    end
  end
end
