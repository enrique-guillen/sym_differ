# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/checkers/sum_token_checker"

require "sym_differ/expression_text_language_compiler/commands/build_sum_expression_command"
require "sym_differ/expression_text_language_compiler/tokens/operator_token"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Checkers::SumTokenChecker do
  describe "#check" do
    subject(:check) { described_class.new(expression_factory).check(token) }

    let(:expression_factory) { double(:expression_factory) }

    context "when the provided token is +" do
      let(:token) { sum_token }

      it "returns an expression and sets expression location as leftmost_or_infix" do
        expect(check).to include(
          handled: true,
          expression_location: :leftmost_or_infix,
          stack_item: {
            item_type: :pending_command,
            precedence: 0,
            value: a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildSumExpressionCommand)
          }
        )
      end
    end

    context "when the provided token is -" do
      let(:token) { subtract_token }

      it { is_expected.to eq(handled: false) }
    end

    define_method(:sum_token) { operator_token("+") }
    define_method(:subtract_token) { operator_token("-") }

    define_method(:operator_token) do |symbol|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::OperatorToken.new(symbol)
    end
  end
end
