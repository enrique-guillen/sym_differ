# frozen_string_literal: true

require "sym_differ/free_form_expression_text_language/variable_token"
require "sym_differ/free_form_expression_text_language/constant_token"
require "sym_differ/free_form_expression_text_language/operator_token"

require "sym_differ/free_form_expression_text_language/unrecognized_token_error"
require "sym_differ/free_form_expression_text_language/empty_expression_text_error"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Parses an expression written down as text, allowing the user to include as much whitespace as they'd like between
    # tokens of the expression, and returns a list of Free Form Expression Text Tokens.
    class TokenExtractor
      def parse(expression_text)
        raise_error_if_expression_text_is_empty(expression_text)
        extract_tokens(expression_text)
      rescue EmptyExpressionTextError, UnrecognizedTokenError
        raise_unparseable_expression_error
      end

      private

      def extract_tokens(expression_text)
        tokens = []

        until expression_text.empty?
          next_token, new_expression_text =
            remove_leading_whitespace_and_get_next_token_and_expression_text_pair(expression_text)

          expression_text = new_expression_text
          tokens.push(next_token) unless next_token.nil?
        end

        tokens.compact
      end

      def remove_leading_whitespace_and_get_next_token_and_expression_text_pair(expression_text)
        expression_text = remove_leading_whitespace_from_text(expression_text)

        try_to_extract_nil_token_from_expression_head(expression_text) ||
          try_to_extract_operator_token_from_expression_head(expression_text) ||
          try_to_extract_variable_token_from_expression_head(expression_text) ||
          try_to_extract_constant_token_from_expression_head(expression_text) ||
          raise_unparseable_text_error_due_to_unrecognized_token(expression_text)
      end

      def remove_leading_whitespace_from_text(text)
        (text = tail_end_of_text(text)) while character_is_whitespace?(first_character_in_text(text))

        text
      end

      def try_to_extract_nil_token_from_expression_head(expression_text)
        build_nil_token_and_empty_string if expression_text.empty?
      end

      def try_to_extract_operator_token_from_expression_head(expression_text)
        return unless first_character_in_text_is_recognized_infix_operator?(expression_text)

        build_operator_token_and_split_text_on_first_letter(expression_text)
      end

      def try_to_extract_variable_token_from_expression_head(expression_text)
        return unless first_character_in_text_is_alphabetical_letter?(expression_text)

        build_variable_token_with_rest_of_text(expression_text)
      end

      def try_to_extract_constant_token_from_expression_head(expression_text)
        return unless first_character_in_text_is_numeric?(expression_text)

        build_constant_token_and_split_text_on_first_non_numerical_character(expression_text)
      end

      def raise_error_if_expression_text_is_empty(expression_text)
        raise EmptyExpressionTextError if expression_text.empty?
      end

      def raise_unparseable_text_error_due_to_unrecognized_token(expression_text)
        raise UnrecognizedTokenError.new(expression_text)
      end

      def raise_unparseable_expression_error
        raise UnparseableExpressionTextError
      end

      def build_nil_token_and_empty_string
        [nil, ""]
      end

      def first_character_in_text_is_recognized_infix_operator?(text)
        character_is_recognized_infix_operator?(first_character_in_text(text))
      end

      def build_operator_token_and_split_text_on_first_letter(text)
        [build_operator_token(first_character_in_text(text)), tail_end_of_text(text)]
      end

      def first_character_in_text_is_alphabetical_letter?(text)
        character_is_alphabetic?(first_character_in_text(text))
      end

      def build_variable_token_with_rest_of_text(text)
        buffer = []

        while character_is_alphabetic?(first_character_in_text(text))
          buffer.push(first_character_in_text(text))
          text = tail_end_of_text(text)
        end

        [build_variable_token(buffer.join), text]
      end

      def first_character_in_text_is_numeric?(expression_text)
        character_is_numeric?(first_character_in_text(expression_text))
      end

      def build_constant_token_and_split_text_on_first_non_numerical_character(text)
        buffer = []

        while character_is_numeric?(first_character_in_text(text))
          buffer.push(first_character_in_text(text))
          text = tail_end_of_text(text)
        end

        [build_constant_token(buffer.join.to_i), text]
      end

      def tail_end_of_text(text)
        text[1, text.size].to_s
      end

      def first_character_in_text(text)
        text[0].to_s
      end

      def build_operator_token(symbol)
        OperatorToken.new(symbol)
      end

      def build_variable_token(name)
        VariableToken.new(name)
      end

      def build_constant_token(value)
        ConstantToken.new(value)
      end

      def character_is_whitespace?(character)
        character.match?(/\s/)
      end

      def character_is_recognized_infix_operator?(character)
        %w[+ -].include?(character)
      end

      def character_is_alphabetic?(character)
        character.match?(/[a-zA-Z]/)
      end

      def character_is_numeric?(character)
        character.match?(/[0-9]/)
      end
    end
  end
end
