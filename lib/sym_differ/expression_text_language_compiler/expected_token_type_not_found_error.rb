# frozen_string_literal: true

require "sym_differ/error"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Raised when the expression text tokens were being read and, at some point, a token of the expected token types
    # was not found.
    class ExpectedTokenTypeNotFoundError < SymDiffer::Error
      def accept(visitor)
        visitor.visit_expected_token_type_not_found_error(self)
      end
    end
  end
end
