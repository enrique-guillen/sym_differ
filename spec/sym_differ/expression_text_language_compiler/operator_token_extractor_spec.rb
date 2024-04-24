# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/operator_token_extractor"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::OperatorTokenExtractor do
  describe "#extract" do
    subject(:extract) { described_class.new.extract(expression_text) }

    context "when the expression text is +" do
      let(:expression_text) { "+" }

      it "extracts an OperatorToken(+) and returns an empty string" do
        expect(extract).to include(
          handled: true, token: an_object_having_attributes(symbol: "+"), next_expression_text: ""
        )
      end
    end

    context "when the expression text is -" do
      let(:expression_text) { "-" }

      it "extracts an OperatorToken(-) and returns an empty string" do
        expect(extract).to include(
          handled: true, token: an_object_having_attributes(symbol: "-"), next_expression_text: ""
        )
      end
    end

    context "when the expression text is +x" do
      let(:expression_text) { "+x" }

      it "extracts an OperatorToken(-) and returns an empty string" do
        expect(extract).to include(
          handled: true, token: an_object_having_attributes(symbol: "+"), next_expression_text: "x"
        )
      end
    end

    context "when the expression text is x+" do
      let(:expression_text) { "x+" }

      it "extracts an OperatorToken(-) and returns an empty string" do
        expect(extract).to eq(handled: false)
      end
    end
  end
end
