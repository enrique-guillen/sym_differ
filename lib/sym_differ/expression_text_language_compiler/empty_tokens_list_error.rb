# frozen_string_literal: true

require "sym_differ/error"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Raised when the expression text to compile was not tokenized into a non-empty list of tokens.
    class EmptyTokensListError < SymDiffer::Error; end
  end
end
