# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Reduces the terms in the provided positive expression.
    class PositiveExpressionReducer
      def initialize(reducer)
        @reducer = reducer
      end

      def reduce(expression)
        @reducer.reduction_analysis(expression.summand)
      end
    end
  end
end
