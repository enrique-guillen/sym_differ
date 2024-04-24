# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/constant_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Scans the head of the expression text and extracts the token at the head of the expression text if it's a constant
    # value.
    class ConstantTokenExtractor
      def extract(expression_text)
        first_character_in_text = first_character_in_text(expression_text)
        return build_not_handled_response unless numeric_character?(first_character_in_text)

        constant_value, tail_end_of_text = extract_constant_value_and_tail_end_of_text(expression_text)

        token = build_constant_token(constant_value.to_i)
        build_handled_response(token, tail_end_of_text)
      end

      private

      CONSTANT_MATCHER = /[0-9]/
      private_constant :CONSTANT_MATCHER

      def build_not_handled_response
        { handled: false }
      end

      def build_handled_response(token, next_expression_text)
        { handled: true, token:, next_expression_text: }
      end

      def extract_constant_value_and_tail_end_of_text(expression_text)
        constant_value = ""

        while numeric_character?(first_character_in_text(expression_text))
          constant_value += first_character_in_text(expression_text)
          expression_text.text = tail_end_of_text(expression_text)
        end

        [constant_value, expression_text]
      end

      def numeric_character?(character)
        CONSTANT_MATCHER.match?(character)
      end

      def first_character_in_text(expression_text)
        expression_text.first_character_in_text
      end

      def tail_end_of_text(expression_text)
        expression_text.tail_end_of_text
      end

      def build_constant_token(value)
        ConstantToken.new(value)
      end
    end
  end
end
