# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/tokens/parens_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Extractors
      # Scans the head of the expression text and extracts the token at the head of the expression text if it's a
      # parenthesis.
      class ParensTokenExtractor
        def extract(expression_text)
          first_character = first_character_in_text(expression_text)
          return build_not_handled_response unless valid_parens_character?(first_character)

          first_character_in_text = first_character
          expression_text.text = tail_end_of_text(expression_text)

          token = build_token_based_on_first_character_type(first_character_in_text)
          build_handled_response(token, expression_text)
        end

        private

        PAREN_CHARACTERS = %w[( )].freeze
        private_constant :PAREN_CHARACTERS

        def build_token_based_on_first_character_type(character)
          Tokens::ParensToken.new(character == "(" ? :opening : :closing)
        end

        def valid_parens_character?(character)
          PAREN_CHARACTERS.include?(character)
        end

        def build_not_handled_response
          { handled: false }
        end

        def build_handled_response(token, expression_text)
          {
            handled: true,
            token:,
            expression_text:
          }
        end

        def first_character_in_text(expression_text)
          expression_text.first_character_in_text
        end

        def tail_end_of_text(expression_text)
          expression_text.tail_end_of_text
        end
      end
    end
  end
end
