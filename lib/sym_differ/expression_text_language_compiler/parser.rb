# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/token_extractor"
require "sym_differ/expression_text_language_compiler/expression_tree_builder"

require "sym_differ/expression_factory"

require "sym_differ/invalid_variable_given_to_expression_parser_error"
require "sym_differ/expression_text_language_compiler/empty_expression_text_error"
require "sym_differ/expression_text_language_compiler/unrecognized_token_error"
require "sym_differ/expression_text_language_compiler/invalid_syntax_error"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Receives a string and returns an Expression tree representing the expression defined in the string.
    class Parser
      def initialize(expression_factory)
        @expression_factory = expression_factory
      end

      def parse(expression)
        expression_tree_builder
          .build(token_extractor.parse(expression))
      rescue EmptyExpressionTextError, UnrecognizedTokenError, InvalidSyntaxError
        raise_unparseable_expression_error
      end

      def validate_variable(variable)
        return if variable.match?(VARIABLE_NAME_MATCHER)

        raise_invalid_variable_error(variable)
      end

      private

      VARIABLE_NAME_MATCHER = /\A[a-zA-Z]+\z/
      private_constant :VARIABLE_NAME_MATCHER

      def expression_tree_builder
        ExpressionTreeBuilder.new(@expression_factory)
      end

      def token_extractor
        TokenExtractor.new
      end

      def raise_unparseable_expression_error
        raise UnparseableExpressionTextError
      end

      def raise_invalid_variable_error(variable)
        raise InvalidVariableGivenToExpressionParserError.new(variable)
      end
    end
  end
end
