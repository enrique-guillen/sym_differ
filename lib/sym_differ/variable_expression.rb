# frozen_string_literal: true

module SymDiffer
  # Represents an expression with a variable value.
  class VariableExpression
    def initialize(name)
      @name = name
    end

    attr_reader :name
  end
end
