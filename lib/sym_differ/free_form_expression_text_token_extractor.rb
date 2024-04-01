# frozen_string_literal: true

require "sym_differ/unparseable_expression_text_error"

module SymDiffer
  # Parses an expression written down as text, allowing the user to include as much whitespace as they'd like between
  # tokens of the expression, and returns a list of Free Form Expression Text Tokens.
  class FreeFormExpressionTextTokenExtractor
    def parse(expression_text)
      raise_error_if_expression_text_is_empty(expression_text)

      extract_tokens(expression_text)
    end

    private

    def raise_error_if_expression_text_is_empty(expression_text)
      raise_unparseable_text_error_due_to_empty_text(expression_text) if expression_text.empty?
    end

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

      if expression_text.empty?
        build_nil_token_and_empty_string
      elsif first_character_in_text_is_dash?(expression_text)
        build_negate_token_and_split_text_on_first_letter(expression_text)
      elsif first_character_in_text_is_plus?(expression_text)
        build_sum_token_and_split_text_on_first_letter(expression_text)
      elsif first_character_in_text_is_alphabetical_letter?(expression_text)
        build_variable_token_with_rest_of_text(expression_text)
      elsif first_character_in_text_is_numeric?(expression_text)
        build_constant_token_and_split_text_on_first_non_numerical_character(expression_text)
      else
        raise_unparseable_text_error_due_to_unrecognized_token(expression_text)
      end
    end

    def remove_leading_whitespace_from_text(text)
      (text = tail_end_of_text(text)) while character_is_whitespace?(first_character_in_text(text))

      text
    end

    def build_nil_token_and_empty_string
      [nil, ""]
    end

    def first_character_in_text_is_dash?(text)
      first_character_in_text(text) == "-"
    end

    def build_negate_token_and_split_text_on_first_letter(text)
      [build_negate_token, tail_end_of_text(text)]
    end

    def first_character_in_text_is_plus?(text)
      first_character_in_text(text) == "+"
    end

    def build_sum_token_and_split_text_on_first_letter(text)
      [build_sum_token, tail_end_of_text(text)]
    end

    def first_character_in_text_is_alphabetical_letter?(text)
      character_is_alphabetic?(first_character_in_text(text))
    end

    def build_variable_token_with_rest_of_text(expression_text)
      [build_variable_token(expression_text), ""]
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

    def raise_unparseable_text_error_due_to_empty_text(text)
      raise_unparseable_text_error("The expression can't be empty.", text)
    end

    def raise_unparseable_text_error_due_to_unrecognized_token(expression_text)
      raise_unparseable_text_error(
        "A token in the expression started with unrecognized token '#{first_character_in_text(expression_text)}'.",
        expression_text
      )
    end

    def tail_end_of_text(text)
      text[1, text.size].to_s
    end

    def first_character_in_text(text)
      text[0].to_s
    end

    def build_negate_token
      OperationToken.new("-")
    end

    def build_sum_token
      OperationToken.new("+")
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

    def character_is_alphabetic?(character)
      character.match?(/[a-zA-Z]/)
    end

    def character_is_numeric?(character)
      character.match?(/[0-9]/)
    end

    def raise_unparseable_text_error(reason, text)
      raise UnparseableExpressionTextError.new(reason, text)
    end
  end
end
