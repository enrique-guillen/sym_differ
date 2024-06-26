# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/tokens/identifier_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Extractors
      # Scans the head of the expression text and extracts the token at the head of the expression text if it's a
      # variable name.
      class IdentifierTokenExtractor
        def extract(expression_text)
          first_character_in_text = first_character_in_text(expression_text)
          return build_not_handled_response unless valid_variable_character?(first_character_in_text)

          variable_name, tail_end_of_text = extract_variable_name_and_tail_end_of_text(expression_text)

          token = build_identifier_token(variable_name)
          build_handled_response(token, tail_end_of_text)
        end

        private

        VARIABLE_NAME_MATCHER = /[a-zA-Z]/
        private_constant :VARIABLE_NAME_MATCHER

        def build_not_handled_response
          { handled: false }
        end

        def build_handled_response(token, next_expression_text)
          { handled: true, token:, next_expression_text: }
        end

        def extract_variable_name_and_tail_end_of_text(expression_text)
          variable_name = ""

          while valid_variable_character?(first_character_in_text(expression_text))
            variable_name += first_character_in_text(expression_text)
            expression_text.text = tail_end_of_text(expression_text)
          end

          [variable_name, expression_text]
        end

        def valid_variable_character?(character)
          VARIABLE_NAME_MATCHER.match?(character)
        end

        def first_character_in_text(text)
          text.first_character_in_text
        end

        def tail_end_of_text(text)
          text.tail_end_of_text
        end

        def build_identifier_token(name)
          Tokens::IdentifierToken.new(name)
        end
      end
    end
  end
end
