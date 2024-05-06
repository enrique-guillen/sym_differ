# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/checkers/identifier_token_checker"

require "sym_differ/expression_text_language_compiler/tokens/identifier_token"
require "sym_differ/expression_text_language_compiler/tokens/constant_token"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Checkers::IdentifierTokenChecker do
  describe "#check" do
    subject(:check) { described_class.new(expression_factory).check(token) }

    let(:expression_factory) { sym_differ_expression_factory }

    context "when the provided token is x" do
      let(:token) { identifier_token("x") }

      it "returns an expression and sets expression location as rightmost" do
        expect(check).to include(
          handled: true,
          expression_location: :rightmost,
          stack_item: {
            item_type: :pending_command, precedence: 9, min_argument_amount: 0, max_argument_amount: 1,
            value: a_kind_of(
              SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildIdentifierExpressionCommand
            ).and(having_attributes(identifier_name: "x"))
          }
        )
      end
    end

    context "when the provided token is 1" do
      let(:token) { constant_token(1) }

      it { is_expected.to eq(handled: false) }
    end

    define_method(:constant_token) do |value|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::ConstantToken.new(value)
    end

    define_method(:identifier_token) do |name|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::IdentifierToken.new(name)
    end
  end
end
