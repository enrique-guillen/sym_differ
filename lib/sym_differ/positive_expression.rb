# frozen_string_literal: true

module SymDiffer
  # Represents an expression whose value is the nested expression (summand).
  class PositiveExpression
    def initialize(summand)
      @summand = summand
    end

    attr_reader :summand

    def accept(visitor)
      visitor.visit_positive_expression(self)
    end
  end
end
