# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/constant_token_extractor"
require "sym_differ/expression_text_language_compiler/expression_text"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::ConstantTokenExtractor do
  describe "#extract" do
    subject(:extract) { described_class.new.extract(expression_text) }

    context "when expression text is 1" do
      let(:expression_text) { create_expression_text("1") }

      it "extracts the constant 1 and returns the empty string" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(value: 1),
          next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    context "when expression text is -1" do
      let(:expression_text) { create_expression_text("-1") }

      it "returns a not-handled response" do
        expect(extract).to include(handled: false)
      end
    end

    context "when expression text is 1+" do
      let(:expression_text) { create_expression_text("1+") }

      it "extracts the constant 1 and returns the string +" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(value: 1),
          next_expression_text: an_object_having_attributes(text: "+")
        )
      end
    end

    context "when expression text is 2" do
      let(:expression_text) { create_expression_text("2") }

      it "extracts the constant 1 and returns the string +" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(value: 2),
          next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    context "when expression text is 42" do
      let(:expression_text) { create_expression_text("42") }

      it "extracts the constant 1 and returns the string +" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(value: 42),
          next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    define_method(:create_expression_text) do |text|
      SymDiffer::ExpressionTextLanguageCompiler::ExpressionText.new(text)
    end
  end
end
