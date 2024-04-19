# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/constant_token_checker"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::ConstantTokenChecker do
  describe "#check" do
    subject(:check) { described_class.new.check(token) }

    context "when the provided token is 1" do
      let(:token) { constant_token(1) }

      it "returns an expression and sets expression location as rightmost" do
        expect(check).to include(
          handled: true,
          expression_location: :rightmost,
          stack_item: { item_type: :expression, value: an_object_having_attributes(value: 1) }
        )
      end
    end

    context "when the provided token is x" do
      let(:token) { variable_token("x") }

      it { is_expected.to eq(handled: false) }
    end

    define_method(:constant_token) do |value|
      SymDiffer::FreeFormExpressionTextLanguage::ConstantToken.new(value)
    end

    define_method(:variable_token) do |name|
      SymDiffer::FreeFormExpressionTextLanguage::VariableToken.new(name)
    end
  end
end
