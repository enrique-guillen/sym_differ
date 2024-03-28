# frozen_string_literal: true

require "sym_differ/constant_expression"

module SymDiffer
  module Differentiation
    # Computes the expression that represents the derivative of a constant function.
    class DeriveConstantExpression
      def derive(_expression)
        ConstantExpression.new(0)
      end
    end
  end
end
