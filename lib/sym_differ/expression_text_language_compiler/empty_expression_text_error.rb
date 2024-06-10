# frozen_string_literal: true

require "sym_differ/error"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Error to raise when an attempt to parse an empty string is made.
    class EmptyExpressionTextError < SymDiffer::Error
      def accept(visitor)
        visitor.visit_empty_expression_text_error(self)
      end
    end
  end
end
