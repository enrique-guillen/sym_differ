# frozen_string_literal: true

module SymDiffer
  # The expression parser cannot parse an expression because the provided variable is considered invalid.
  class InvalidVariableGivenToExpressionParserError < StandardError
    def initialize(invalid_variable_name)
      super()
      @invalid_variable_name = invalid_variable_name
    end

    attr_reader :invalid_variable_name
  end
end
