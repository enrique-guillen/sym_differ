# frozen_string_literal: true

module SymDiffer
  # Represents the subtraction of two nested expressions.
  class SubtractExpression
    def initialize(minuend, subtrahend)
      @minuend = minuend
      @subtrahend = subtrahend
    end

    attr_reader :minuend, :subtrahend

    def accept(visitor)
      visitor.visit_subtract_expression(self)
    end
  end
end
