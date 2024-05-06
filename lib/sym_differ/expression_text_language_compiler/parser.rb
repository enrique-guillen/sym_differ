# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/token_extractor"
require "sym_differ/expression_text_language_compiler/expression_tree_builder"

require "sym_differ/expression_text_language_compiler/tokens/identifier_token"
require "sym_differ/expression_text_language_compiler/tokens/constant_token"
require "sym_differ/expression_text_language_compiler/tokens/operator_token"

require "sym_differ/expression_text_language_compiler/extractors/nil_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/operator_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/constant_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/identifier_token_extractor"

require "sym_differ/expression_text_language_compiler/checkers/constant_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/identifier_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/subtraction_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/sum_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/multiplication_token_checker"

require "sym_differ/expression_text_language_compiler/command_and_expression_stack_reducer"

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

      def parse(expression_text)
        tokens = extract_tokens_from_expression(expression_text)
        convert_tokens_into_expression(tokens)
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

      def extract_tokens_from_expression(expression_text)
        token_extractor.parse(expression_text)
      end

      def convert_tokens_into_expression(tokens)
        expression_tree_builder.build(tokens)
      end

      def token_extractor
        subextractors = token_type_specific_extractors
        TokenExtractor.new(subextractors)
      end

      def expression_tree_builder
        checkers = token_type_specific_checkers
        ExpressionTreeBuilder.new(command_and_expression_stack_reducer, checkers)
      end

      def command_and_expression_stack_reducer
        CommandAndExpressionStackReducer.new
      end

      def token_type_specific_extractors
        @token_type_specific_extractors ||= [
          nil_token_extractor, operator_token_extractor, identifier_token_extractor, constant_token_extractor
        ].freeze
      end

      def token_type_specific_checkers
        @token_type_specific_checkers = {
          prefix_token_checkers: [
            constant_token_checker, identifier_token_checker, subtraction_token_checker, sum_token_checker
          ],
          infix_token_checkers: [multiplication_token_checker, sum_token_checker, subtraction_token_checker]
        }.freeze
      end

      def nil_token_extractor
        SymDiffer::ExpressionTextLanguageCompiler::Extractors::NilTokenExtractor.new
      end

      def operator_token_extractor
        SymDiffer::ExpressionTextLanguageCompiler::Extractors::OperatorTokenExtractor.new
      end

      def identifier_token_extractor
        SymDiffer::ExpressionTextLanguageCompiler::Extractors::IdentifierTokenExtractor.new
      end

      def constant_token_extractor
        SymDiffer::ExpressionTextLanguageCompiler::Extractors::ConstantTokenExtractor.new
      end

      def constant_token_checker
        @constant_token_checker ||= Checkers::ConstantTokenChecker.new(@expression_factory)
      end

      def identifier_token_checker
        @identifier_token_checker ||= Checkers::IdentifierTokenChecker.new(@expression_factory)
      end

      def subtraction_token_checker
        @subtraction_token_checker ||= Checkers::SubtractionTokenChecker.new(@expression_factory)
      end

      def sum_token_checker
        @sum_token_checker ||= Checkers::SumTokenChecker.new(@expression_factory)
      end

      def multiplication_token_checker
        @multiplication_token_checker ||= Checkers::MultiplicationTokenChecker.new(@expression_factory)
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
