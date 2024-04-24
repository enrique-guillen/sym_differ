# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/variable_token_extractor"
require "sym_differ/expression_text_language_compiler/expression_text"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::VariableTokenExtractor do
  describe "#extract" do
    subject(:extract) { described_class.new.extract(expression_text) }

    context "when the expression is x" do
      let(:expression_text) { create_expression_text("x") }

      it "extracts VariableToken(x) and returns an empty string" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(name: "x"),
          next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    context "when the expression is y" do
      let(:expression_text) { create_expression_text("y") }

      it "extracts VariableToken(y) and returns an empty string" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(name: "y"),
          next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    context "when the expression is y+" do
      let(:expression_text) { create_expression_text("y+") }

      it "extracts VariableToken(y) and returns the string +" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(name: "y"),
          next_expression_text: an_object_having_attributes(text: "+")
        )
      end
    end

    context "when the expression is +y" do
      let(:expression_text) { create_expression_text("+y") }

      it "extracts a not-handled response" do
        expect(extract).to include(handled: false)
      end
    end

    context "when the expression is ZeEpicVarNamex" do
      let(:expression_text) { create_expression_text("ZeEpicVarNamex") }

      it "extracts VariableToken(y) and returns the string +" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(name: "ZeEpicVarNamex"),
          next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    define_method(:create_expression_text) do |text|
      SymDiffer::ExpressionTextLanguageCompiler::ExpressionText.new(text)
    end
  end
end
