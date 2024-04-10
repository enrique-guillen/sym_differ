# frozen_string_literal: true

require "sym_differ/unparseable_expression_text_error"

module SymDiffer
  module FreeFormExpressionTextLanguage
    class UnrecognizedTokenError < UnparseableExpressionTextError
      def initialize(invalid_expression_text)
        super(invalid_expression_text)
        @invalid_expression_text = invalid_expression_text
      end
    end
  end
end
