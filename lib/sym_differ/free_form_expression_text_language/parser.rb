# frozen_string_literal: true

require "sym_differ/free_form_expression_text_language/token_extractor"
require "sym_differ/free_form_expression_text_language/expression_tree_builder"

require "sym_differ/invalid_variable_given_to_expression_parser_error"

require "sym_differ/free_form_expression_text_language/empty_expression_text_error"
require "sym_differ/free_form_expression_text_language/unrecognized_token_error"
require "sym_differ/free_form_expression_text_language/invalid_syntax_error"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Receives a string and returns an Expression tree representing the expression defined in the string.
    class Parser
      def parse(expression)
        ExpressionTreeBuilder
          .new
          .build(TokenExtractor.new.parse(expression))
      rescue EmptyExpressionTextError, UnrecognizedTokenError, InvalidSyntaxError
        raise_unparseable_expression_error
      end

      def validate_variable(variable)
        return if variable.match?(/\A[a-zA-Z]+\z/)

        raise_invalid_variable_error(variable)
      end

      private

      def raise_unparseable_expression_error
        raise UnparseableExpressionTextError
      end

      def raise_invalid_variable_error(variable)
        raise InvalidVariableGivenToExpressionParserError.new(variable)
      end
    end
  end
end
