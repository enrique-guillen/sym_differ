# frozen_string_literal: true

module SymDiffer
  # The expression parser cannot parse an expression because the provided variable is considered invalid.
  class UnparseableExpressionTextError < StandardError
  end
end
