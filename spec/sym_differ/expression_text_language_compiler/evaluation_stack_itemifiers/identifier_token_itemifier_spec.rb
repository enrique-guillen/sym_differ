# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/evaluation_stack_itemifiers/identifier_token_itemifier"

require "sym_differ/expression_text_language_compiler/tokens/identifier_token"
require "sym_differ/expression_text_language_compiler/tokens/constant_token"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::EvaluationStackItemifiers::IdentifierTokenItemifier do
  describe "#check" do
    subject(:check) { described_class.new(expression_factory).check(token) }

    let(:expression_factory) { sym_differ_expression_factory }

    context "when the provided token is x" do
      let(:token) { identifier_token("x") }

      it "returns an expression and sets expression location as rightmost" do
        expect(check).to include(
          successfully_handled_response(
            :post_identifier_token_checkers,
            command_stack_item(
              6,
              (0..1),
              a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildIdentifierExpressionCommand)
                .and(having_attributes(identifier_name: "x"))
            )
          )
        )
      end
    end

    context "when the provided token is 1" do
      let(:token) { constant_token(1) }

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

    define_method(:constant_token) do |value|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::ConstantToken.new(value)
    end

    define_method(:identifier_token) do |name|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::IdentifierToken.new(name)
    end
  end
end
