# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/checkers/division_token_checker"

require "sym_differ/expression_text_language_compiler/commands/build_divide_expression_command"
require "sym_differ/expression_text_language_compiler/tokens/operator_token"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Checkers::DivisionTokenChecker do
  describe "#check" do
    subject(:check) do
      described_class.new.check(token)
    end

    let(:expression_factory) { double(:expression_factory) }

    context "when the provided token is *" do
      let(:token) { operator_token("/") }

      it "returns an expression and indicates the follow up token type" do
        expect(check).to include(
          successfully_handled_response(
            :post_division_token_checkers,
            command_stack_item(
              4,
              (2..2),
              a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildDivideExpressionCommand)
            )
          )
        )
      end
    end

    context "when the provided token is ^" do
      let(:token) { operator_token("^") }

      it { is_expected.to eq(handled: false) }
    end

    define_method(:successfully_handled_response) do |next_expected_token_type, stack_item|
      { handled: true, next_expected_token_type:, stack_item: }
    end

    define_method(:command_stack_item) do |precedence, argument_amount_range, value|
      {
        item_type: :pending_command,
        precedence:,
        min_argument_amount: argument_amount_range.min,
        max_argument_amount: argument_amount_range.max,
        value:
      }
    end

    define_method(:operator_token) do |symbol|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::OperatorToken.new(symbol)
    end
  end
end
