# frozen_string_literal: true

module SymDiffer
  # Represents an expression whose value is the negative value of the nested expression.
  class NegateExpression
    def initialize(negated_expression)
      @negated_expression = negated_expression
    end

    attr_reader :negated_expression
  end
end
