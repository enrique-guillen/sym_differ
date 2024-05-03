# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/checkers/multiplication_token_checker"

require "sym_differ/expression_text_language_compiler/commands/build_multiplicate_expression_command"
require "sym_differ/expression_text_language_compiler/tokens/operator_token"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Checkers::MultiplicationTokenChecker do
  describe "#check" do
    subject(:check) { described_class.new(expression_factory).check(token) }

    let(:expression_factory) { double(:expression_factory) }

    context "when the provided token is *" do
      let(:token) { operator_token("*") }

      it "returns an expression and sets expression location as infix" do
        expect(check).to include(
          handled: true,
          expression_location: :infix,
          stack_item: {
            item_type: :pending_command,
            precedence: 2,
            value: a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildMultiplicateExpressionCommand)
          }
        )
      end
    end

    context "when the provided token is -" do
      let(:token) { operator_token("-") }

      it { is_expected.to eq(handled: false) }
    end

    define_method(:operator_token) do |symbol|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::OperatorToken.new(symbol)
    end
  end
end
