# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/subtraction_token_checker"
require "sym_differ/free_form_expression_text_language/build_subtract_expression_command"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::SubtractionTokenChecker do
  describe "#check" do
    subject(:check) { described_class.new.check(token) }

    context "when the token being checked is -" do
      let(:token) { operator_token("-") }

      it "returns an expression and sets expression location as leftmost_or_infix" do
        expect(check).to include(
          handled: true,
          expression_location: :leftmost_or_infix,
          stack_item: { item_type: :pending_command,
                        value: a_kind_of(SymDiffer::FreeFormExpressionTextLanguage::BuildSubtractExpressionCommand) }
        )
      end
    end

    context "when the token being checked is +" do
      let(:token) { operator_token("+") }

      it { is_expected.to eq(handled: false) }
    end

    define_method(:operator_token) do |symbol|
      SymDiffer::FreeFormExpressionTextLanguage::OperatorToken.new(symbol)
    end
  end
end
