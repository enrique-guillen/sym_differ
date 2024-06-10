# frozen_string_literal: true

require "sym_differ/error"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Raised when the expression text to compile was terminated in a gramatically-incorrect token, thus making it not
    # possible to convert the expression text into a single expression.
    class InvalidTokenTerminatedExpressionError < SymDiffer::Error
      def accept(visitor)
        visitor.visit_invalid_token_terminated_expression_error(self)
      end
    end
  end
end
