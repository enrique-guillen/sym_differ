# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/checkers/subtraction_token_checker"
require "sym_differ/expression_text_language_compiler/commands/build_subtract_expression_command"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Checkers::SubtractionTokenChecker do
  describe "#check" do
    subject(:check) do
      described_class.new(expression_factory).check(token)
    end

    let(:expression_factory) { double(:expression_factory) }

    context "when the token being checked is -" do
      let(:token) { operator_token("-") }

      it "returns an expression and sets expression location as leftmost_or_infix" do
        expect(check).to include(
          handled: true,
          expression_location: :leftmost_or_infix,
          stack_item: {
            item_type: :pending_command,
            precedence: 1,
            value: a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildSubtractExpressionCommand)
          }
        )
      end
    end

    context "when the token being checked is +" do
      let(:token) { operator_token("+") }

      it { is_expected.to eq(handled: false) }
    end

    define_method(:operator_token) do |symbol|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::OperatorToken.new(symbol)
    end
  end
end
