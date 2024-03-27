# frozen_string_literal: true

module SymDiffer
  # Represents an expression representing a fixed value.
  class ConstantExpression
    def initialize(value)
      @value = value
    end

    attr_reader :value
  end
end
