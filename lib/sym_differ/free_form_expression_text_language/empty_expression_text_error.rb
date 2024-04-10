# frozen_string_literal: true

require "sym_differ/unparseable_expression_text_error"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Error to raise when an attempt to parse an empty string is made.
    class EmptyExpressionTextError < StandardError
      def initialize(invalid_expression_text)
        super()
        @invalid_expression_text = invalid_expression_text
      end

      attr_reader :invalid_expression_text
    end
  end
end
