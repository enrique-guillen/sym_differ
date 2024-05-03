# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/tokens/operator_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Scans the head of the expression text and determines if there's an operator token at the head to extract. Splits
    # the text after the operator if so.
    class OperatorTokenExtractor
      def extract(expression_text)
        first_character_in_text = first_character_in_text(expression_text)
        return build_not_handled_response unless character_recognized?(first_character_in_text)

        token = build_operator_token(first_character_in_text)
        expression_text.text = tail_end_of_text(expression_text)
        build_handled_response(token, expression_text)
      end

      private

      RECOGNIZED_OPERATOR = %w[+ - *].freeze
      private_constant :RECOGNIZED_OPERATOR

      def character_recognized?(character)
        RECOGNIZED_OPERATOR.include?(character)
      end

      def build_handled_response(token, next_expression_text)
        { handled: true, token:, next_expression_text: }
      end

      def build_not_handled_response
        { handled: false }
      end

      def first_character_in_text(text)
        text.first_character_in_text
      end

      def tail_end_of_text(text)
        text.tail_end_of_text
      end

      def build_operator_token(symbol)
        Tokens::OperatorToken.new(symbol)
      end
    end
  end
end
