# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/token_extractor"
require "sym_differ/expression_text_language_compiler/expression_tree_builder"

require "sym_differ/expression_text_language_compiler/extractors/nil_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/operator_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/constant_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/parens_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/identifier_token_extractor"

require "sym_differ/expression_text_language_compiler/checkers/constant_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/identifier_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/subtraction_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/sum_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/multiplication_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/parens_token_checker"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Returns the Extractors and Checkers required by the Expression Text Language Parser+dependencies so that, when
    # the Parser and its dependencies are combined, the resulting Parser can parse all the expressions that are possible
    # to construct from our SymDiffer Token+Grammar definition.
    class ApplicationLanguageDefiner
      def initialize(expression_factory)
        @expression_factory = expression_factory
      end

      def token_type_specific_extractors
        @token_type_specific_extractors ||= [
          nil_token_extractor, operator_token_extractor, identifier_token_extractor, constant_token_extractor,
          parens_token_extractor
        ].freeze
      end

      def token_type_specific_checkers
        @token_type_specific_checkers = {
          initial_token_checkers:,
          post_constant_token_checkers:,
          post_identifier_token_checkers:,
          post_multiplication_token_checkers:,
          post_sum_token_checkers:,
          post_subtraction_token_checkers:,
          post_opening_parenthesis: post_opening_parenthesis_checkers,
          post_closing_parenthesis: post_closing_parenthesis_checkers
        }.freeze
      end

      def invalid_expected_token_type_end_states
        %i[post_sum_token_checkers post_subtraction_token_checkers post_opening_parenthesis]
      end

      private

      def initial_token_checkers
        [constant_token_checker, identifier_token_checker, subtraction_token_checker, sum_token_checker]
      end

      def post_constant_token_checkers
        [subtraction_token_checker, sum_token_checker, multiplication_token_checker, parens_token_checker]
      end

      def post_identifier_token_checkers
        [subtraction_token_checker, sum_token_checker, multiplication_token_checker, parens_token_checker]
      end

      def post_multiplication_token_checkers
        [constant_token_checker, identifier_token_checker, sum_token_checker, subtraction_token_checker]
      end

      def post_sum_token_checkers
        [
          constant_token_checker, identifier_token_checker, subtraction_token_checker, sum_token_checker,
          parens_token_checker
        ]
      end

      def post_subtraction_token_checkers
        [constant_token_checker, identifier_token_checker, subtraction_token_checker, sum_token_checker]
      end

      def post_opening_parenthesis_checkers
        [identifier_token_checker, constant_token_checker, subtraction_token_checker, sum_token_checker]
      end

      def post_closing_parenthesis_checkers
        [subtraction_token_checker, sum_token_checker, multiplication_token_checker, parens_token_checker]
      end

      def parens_token_extractor
        SymDiffer::ExpressionTextLanguageCompiler::Extractors::ParensTokenExtractor.new
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

      def parens_token_checker
        @parens_token_checker ||= SymDiffer::ExpressionTextLanguageCompiler::Checkers::ParensTokenChecker.new
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
    end
  end
end
