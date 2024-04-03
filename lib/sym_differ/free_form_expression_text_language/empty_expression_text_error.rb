# frozen_string_literal: true

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Error to raise when an attempt to parse an empty string is made.
    class EmptyExpressionTextError < SymDiffer::UnparseableExpressionTextError
    end
  end
end
