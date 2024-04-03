# frozen_string_literal: true

require "sym_differ/unparseable_expression_text_error"

module SymDiffer
  module FreeFormExpressionTextLanguage
    class UnrecognizedTokenError < UnparseableExpressionTextError
    end
  end
end
