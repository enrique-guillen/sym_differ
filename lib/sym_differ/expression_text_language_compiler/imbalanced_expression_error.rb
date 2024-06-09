# frozen_string_literal: true

require "sym_differ/error"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Raised when the expression text was terminated without the precedence levels being balanced by the time the
    # expression was fully read.
    class ImbalancedExpressionError < SymDiffer::Error; end
  end
end
