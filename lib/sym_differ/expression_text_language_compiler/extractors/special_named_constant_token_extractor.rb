# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/tokens/special_named_constant_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Extractors
      # Scans the head of the expression text and extracts the token at the head of the expression text if it's a
      # special named constant.
      class SpecialNamedConstantTokenExtractor
        def extract(expression_text)
          first_character_in_text = first_character_in_text(expression_text)
          return build_not_handled_response unless first_character_in_text == "~"

          expression_text.text = tail_end_of_text(expression_text)

          constant_name, tail_end_expression_text =
            extract_constant_name_and_tail_end_of_text(expression_text)

          token = build_special_named_constant_token(constant_name)
          build_handled_response(token, tail_end_expression_text)
        end

        private

        def build_handled_response(token, next_expression_text)
          { handled: true, token:, next_expression_text: }
        end

        def build_not_handled_response
          { handled: false }
        end

        def extract_constant_name_and_tail_end_of_text(expression_text)
          name = ""

          while valid_constant_name_character?(first_character_in_text(expression_text))
            name += first_character_in_text(expression_text)
            expression_text.text = tail_end_of_text(expression_text)
          end

          [name, expression_text]
        end

        def first_character_in_text(text)
          text.first_character_in_text
        end

        def tail_end_of_text(text)
          text.tail_end_of_text
        end

        def build_special_named_constant_token(*)
          Tokens::SpecialNamedConstantToken.new(*)
        end

        def valid_constant_name_character?(character)
          SPECIAL_CONSTANT_NAME_MATCHER.match?(character)
        end

        SPECIAL_CONSTANT_NAME_MATCHER = /[a-zA-Z]/
        private_constant :SPECIAL_CONSTANT_NAME_MATCHER
      end
    end
  end
end
