# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/tokens/variable_token"
require "sym_differ/expression_text_language_compiler/tokens/constant_token"
require "sym_differ/expression_text_language_compiler/tokens/operator_token"

require "sym_differ/expression_text_language_compiler/expression_text"
require "sym_differ/expression_text_language_compiler/extractors/nil_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/operator_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/constant_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/variable_token_extractor"

require "sym_differ/expression_text_language_compiler/unrecognized_token_error"
require "sym_differ/expression_text_language_compiler/empty_expression_text_error"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Parses an expression written down as text, allowing the user to include as much whitespace as they'd like between
    # tokens of the expression, and returns a list of Free Form Expression Text Tokens.
    class TokenExtractor
      def parse(expression_text)
        expression_text = ExpressionText.new(expression_text)
        raise_error_if_expression_text_is_empty(expression_text)

        extract_tokens(expression_text)
      end

      private

      def extract_tokens(expression_text)
        tokens = []

        until expression_text.empty?
          expression_text = remove_leading_whitespace_from_text(expression_text)
          next_token, expression_text = get_next_token_and_expression_text_pair(expression_text)

          tokens.push(next_token) unless next_token.nil?
        end

        tokens.compact
      end

      def remove_leading_whitespace_from_text(expression_text)
        while character_is_whitespace?(first_character_in_text(expression_text))
          (expression_text.text = tail_end_of_text(expression_text))
        end

        expression_text
      end

      def get_next_token_and_expression_text_pair(expression_text)
        extract_token_response = nil

        token_extractors.detect do |extractor|
          extract_token_response = extract_token_and_next_expression_text(extractor, expression_text)
          !extract_token_response.nil?
        end

        raise_unrecognized_token_error(expression_text) if extract_token_response.nil?

        [extract_token_response[:token], extract_token_response[:next_expression_text]]
      end

      def extract_token_and_next_expression_text(extractor, expression_text)
        extract_token_response = extractor.extract(expression_text)
        return unless extract_token_response[:handled]

        extract_token_response
      end

      def token_extractors
        @token_extractors ||= [
          Extractors::NilTokenExtractor.new,
          Extractors::OperatorTokenExtractor.new,
          Extractors::VariableTokenExtractor.new,
          Extractors::ConstantTokenExtractor.new
        ]
      end

      def raise_error_if_expression_text_is_empty(expression_text)
        raise EmptyExpressionTextError if expression_text.empty?
      end

      def raise_unrecognized_token_error(expression_text)
        raise UnrecognizedTokenError.new(expression_text.text)
      end

      def tail_end_of_text(text)
        text.tail_end_of_text
      end

      def first_character_in_text(text)
        text.first_character_in_text
      end

      def character_is_whitespace?(character)
        character.match?(/\s/)
      end
    end
  end
end

