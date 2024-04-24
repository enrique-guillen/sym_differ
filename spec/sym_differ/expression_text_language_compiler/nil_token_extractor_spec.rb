# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/nil_token_extractor"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::NilTokenExtractor do
  describe "#extract" do
    subject(:extract) { described_class.new.extract(expression_text) }

    context "when expression text is empty" do
      let(:expression_text) { create_expression_text("") }

      it "returns a handled response with nil token and empty string" do
        expect(extract).to include(
          handled: true, token: nil, next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    context "when expression text is x" do
      let(:expression_text) { create_expression_text("x") }

      it { is_expected.to eq(handled: false) }
    end

    define_method(:create_expression_text) do |text|
      SymDiffer::ExpressionTextLanguageCompiler::ExpressionText.new(text)
    end
  end
end
