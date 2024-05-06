# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/extractors/parens_token_extractor"

require "sym_differ/expression_text_language_compiler/expression_text"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Extractors::ParensTokenExtractor do
  describe "#extract" do
    subject(:extract) do
      described_class.new.extract(expression_text)
    end

    context "when the expression text = (" do
      let(:expression_text) { create_expression_text("(") }

      it "extracts the open parens and returns the empty string" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(type: :opening),
          next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    context "when the expression text = )" do
      let(:expression_text) { create_expression_text(")") }

      it "extracts the open parens and returns the empty string" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(type: :closing),
          next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    context "when the expression text = (x" do
      let(:expression_text) { create_expression_text("(x") }

      it "extracts the open parens and returns the empty string" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(type: :opening),
          next_expression_text: an_object_having_attributes(text: "x")
        )
      end
    end

    context "when the expression text = x" do
      let(:expression_text) { create_expression_text("x") }

      it "extracts the open parens and returns the empty string" do
        expect(extract).to include(handled: false)
      end
    end

    define_method(:create_expression_text) do |text|
      SymDiffer::ExpressionTextLanguageCompiler::ExpressionText.new(text)
    end
  end
end
