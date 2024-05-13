# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Raised when the expression is not parseable due to its grammar not being recognized.
    class InvalidSyntaxError < StandardError
      def initialize(invalid_expression_text)
        super()
        @invalid_expression_text = invalid_expression_text
      end

      attr_reader :invalid_expression_text
    end
  end
end
