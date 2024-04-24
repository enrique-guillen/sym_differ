# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Scans the head of the expression text and determines if there's no token to extract from the expression, e.g.,
    # because it's empty.
    class NilTokenExtractor
      def extract(expression_text)
        if expression_text.empty?
          build_handled_response
        else
          build_not_handled_response
        end
      end

      private

      def build_handled_response
        { handled: true, token: nil, next_expression_text: "" }
      end

      def build_not_handled_response
        { handled: false }
      end
    end
  end
end
