# frozen_string_literal: true

module SymDiffer
  # Represents the sum of two nested expressions.
  class SumExpression
    def initialize(expression_a, expression_b)
      @expression_a = expression_a
      @expression_b = expression_b
    end

    attr_reader :expression_a, :expression_b
  end
end
