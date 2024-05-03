# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/extractors/operator_token_extractor"
require "sym_differ/expression_text_language_compiler/expression_text"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Extractors::OperatorTokenExtractor do
  describe "#extract" do
    subject(:extract) { described_class.new.extract(expression_text) }

    context "when the expression text is +" do
      let(:expression_text) { create_expression_text("+") }

      it "extracts an OperatorToken(+) and returns an empty string" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(symbol: "+"),
          next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    context "when the expression text is -" do
      let(:expression_text) { create_expression_text("-") }

      it "extracts an OperatorToken(-) and returns an empty string" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(symbol: "-"),
          next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    context "when the expression text is +x" do
      let(:expression_text) { create_expression_text("+x") }

      it "extracts an OperatorToken(+) and returns the string x" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(symbol: "+"),
          next_expression_text: an_object_having_attributes(text: "x")
        )
      end
    end

    context "when the expression text is *" do
      let(:expression_text) { create_expression_text("*") }

      it "extracts an OperatorToken(-) and returns an empty string" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(symbol: "*"),
          next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    context "when the expression text is x+" do
      let(:expression_text) { create_expression_text("x+") }

      it "returns handled: false" do
        expect(extract).to eq(handled: false)
      end
    end

    define_method(:create_expression_text) do |text|
      SymDiffer::ExpressionTextLanguageCompiler::ExpressionText.new(text)
    end
  end
end
