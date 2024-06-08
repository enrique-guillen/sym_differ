# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/token_extractor"
require "sym_differ/expression_text_language_compiler/expression_tree_builder"

require "sym_differ/expression_text_language_compiler/extractors/nil_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/operator_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/constant_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/parens_token_extractor"
require "sym_differ/expression_text_language_compiler/extractors/identifier_token_extractor"

require "sym_differ/expression_text_language_compiler/evaluation_stack_itemifiers/constant_token_itemifier"
require "sym_differ/expression_text_language_compiler/evaluation_stack_itemifiers/identifier_token_itemifier"
require "sym_differ/expression_text_language_compiler/evaluation_stack_itemifiers/subtraction_token_itemifier"
require "sym_differ/expression_text_language_compiler/evaluation_stack_itemifiers/sum_token_itemifier"
require "sym_differ/expression_text_language_compiler/evaluation_stack_itemifiers/multiplication_token_itemifier"
require "sym_differ/expression_text_language_compiler/evaluation_stack_itemifiers/parens_token_itemifier"
require "sym_differ/expression_text_language_compiler/evaluation_stack_itemifiers/division_token_itemifier"
require "sym_differ/expression_text_language_compiler/evaluation_stack_itemifiers/exponentiation_token_itemifier"

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

      def token_type_specific_itemifiers
        @token_type_specific_itemifier = {
          initial_token_checkers: sub_expression_starters,
          post_constant_token_checkers: possible_infix_operators,
          post_identifier_token_checkers: possible_infix_operators,
          post_multiplication_token_checkers: sub_expression_starters,
          post_sum_token_checkers: sub_expression_starters,
          post_subtraction_token_checkers: sub_expression_starters,
          post_division_token_checkers: sub_expression_starters,
          post_exponentiation_token_checkers: sub_expression_starters,
          post_opening_parenthesis: sub_expression_starters,
          post_closing_parenthesis: possible_infix_operators
        }.freeze
      end

      def invalid_expected_token_type_end_states
        %i[
          post_sum_token_checkers post_subtraction_token_checkers post_opening_parenthesis
          post_multiplication_token_checkers post_division_token_checkers post_exponentiation_token_checkers
        ]
      end

      private

      def sub_expression_starters
        [
          constant_token_itemifier, identifier_token_itemifier, subtraction_token_itemifier, sum_token_itemifier,
          parens_token_itemifier
        ]
      end

      def possible_infix_operators
        [
          multiplication_token_itemifier, parens_token_itemifier, subtraction_token_itemifier, sum_token_itemifier,
          division_token_itemifier, exponentiation_token_itemifier
        ]
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

      def parens_token_itemifier
        @parens_token_itemifier ||= EvaluationStackItemifiers::ParensTokenItemifier.new
      end

      def constant_token_itemifier
        @constant_token_itemifier ||= EvaluationStackItemifiers::ConstantTokenItemifier.new(@expression_factory)
      end

      def identifier_token_itemifier
        @identifier_token_itemifier ||= EvaluationStackItemifiers::IdentifierTokenItemifier.new(@expression_factory)
      end

      def subtraction_token_itemifier
        @subtraction_token_itemifier ||= EvaluationStackItemifiers::SubtractionTokenItemifier.new(@expression_factory)
      end

      def sum_token_itemifier
        @sum_token_itemifier ||= EvaluationStackItemifiers::SumTokenItemifier.new(@expression_factory)
      end

      def multiplication_token_itemifier
        @multiplication_token_itemifier ||=
          EvaluationStackItemifiers::MultiplicationTokenItemifier.new(@expression_factory)
      end

      def division_token_itemifier
        @division_token_itemifier ||= EvaluationStackItemifiers::DivisionTokenItemifier.new(@expression_factory)
      end

      def exponentiation_token_itemifier
        @exponentiation_token_itemifier ||=
          EvaluationStackItemifiers::ExponentiationTokenItemifier.new(@expression_factory)
      end
    end
  end
end
