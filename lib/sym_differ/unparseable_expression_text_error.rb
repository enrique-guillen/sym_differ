# frozen_string_literal: true

module SymDiffer
  # The expression parser cannot parse an expression because the provided variable is considered invalid.
  class UnparseableExpressionTextError < StandardError
    def initialize(message, invalid_expression_text)
      super(message)
      @invalid_variable_name = invalid_expression_text
    end

    attr_reader :invalid_expression_text
  end
end
