# frozen_string_literal: true

require "sym_differ/error"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Raised when the expression text tokens were being read and, at some point, a token of the expected token types
    # was not found.
    class ExpectedTokenTypeNotFoundError < SymDiffer::Error; end
  end
end
