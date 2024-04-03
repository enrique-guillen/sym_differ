# frozen_string_literal: true

require "sym_differ/free_form_expression_text_language/token_extractor"
require "sym_differ/free_form_expression_text_language/expression_tree_builder"
require "sym_differ/invalid_variable_given_to_expression_parser_error"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Receives a string and returns an Expression tree representing the expression defined in the string.
    class Parser
      def parse(expression)
        ExpressionTreeBuilder
          .new
          .build(TokenExtractor.new.parse(expression))
      end

      def validate_variable(var)
        return if var.match?(/\A[a-zA-Z]+\z/)

        raise InvalidVariableGivenToExpressionParserError.new(
          "Invalid variable name #{var}; provide a variable name consisting of alphabetical characters only.", var
        )
      end
    end
  end
end
