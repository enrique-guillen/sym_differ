# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/token_extractor"
require "sym_differ/expression_text_language_compiler/expression_tree_builder"

require "sym_differ/expression_text_language_compiler/command_and_expression_stack_reducer"

require "sym_differ/expression_text_language_compiler/invalid_variable_given_to_expression_parser_error"
require "sym_differ/expression_text_language_compiler/empty_expression_text_error"
require "sym_differ/expression_text_language_compiler/unrecognized_token_error"
require "sym_differ/expression_text_language_compiler/invalid_syntax_error"

require "sym_differ/expression_text_language_compiler/application_language_definer"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Receives a string and returns an Expression tree representing the expression defined in the string.
    class Parser
      def initialize(expression_factory)
        @expression_factory = expression_factory
      end

      def parse(expression_text)
        tokens = extract_tokens_from_expression(expression_text)
        convert_tokens_into_expression(tokens)
      end

      def validate_variable(variable)
        return if variable.match?(VARIABLE_NAME_MATCHER)

        raise_invalid_variable_error(variable)
      end

      private

      VARIABLE_NAME_MATCHER = /\A[a-zA-Z]+\z/
      private_constant :VARIABLE_NAME_MATCHER

      def extract_tokens_from_expression(expression_text)
        token_extractor.parse(expression_text)
      end

      def convert_tokens_into_expression(tokens)
        expression_tree_builder.build(tokens)
      end

      def token_extractor
        subextractors = application_token_type_specific_extractors
        TokenExtractor.new(subextractors)
      end

      def expression_tree_builder
        checkers = application_token_type_specific_checkers

        invalid_expected_token_type_end_states = application_invalid_expected_token_type_end_states

        ExpressionTreeBuilder
          .new(command_and_expression_stack_reducer, checkers, invalid_expected_token_type_end_states)
      end

      def application_token_type_specific_extractors
        application_language_definer.token_type_specific_extractors
      end

      def application_token_type_specific_checkers
        application_language_definer.token_type_specific_checkers
      end

      def application_invalid_expected_token_type_end_states
        application_language_definer.invalid_expected_token_type_end_states
      end

      def application_language_definer
        @application_language_definer ||= ApplicationLanguageDefiner.new(@expression_factory)
      end

      def command_and_expression_stack_reducer
        CommandAndExpressionStackReducer.new
      end

      def raise_invalid_variable_error(variable)
        raise InvalidVariableGivenToExpressionParserError.new(variable)
      end
    end
  end
end
