# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/extractors/special_named_constant_token_extractor"

require "sym_differ/expression_text_language_compiler/expression_text"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Extractors::SpecialNamedConstantTokenExtractor do
  describe "#extract" do
    subject(:extract) do
      described_class.new.extract(expression_text)
    end

    context "when the expression text is ~e" do
      let(:expression_text) { create_expression_text("~e") }

      it "returns the expected handled response" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(text: "e"),
          next_expression_text: an_object_having_attributes(text: "")
        )
      end
    end

    context "when the expression text is e" do
      let(:expression_text) { create_expression_text("e") }

      it { is_expected.to include(handled: false) }
    end

    context "when the expression text is ~e+" do
      let(:expression_text) { create_expression_text("~e+") }

      it "returns the expected handled response" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(text: "e"),
          next_expression_text: an_object_having_attributes(text: "+")
        )
      end
    end

    context "when the expression text is ~eAz+" do
      let(:expression_text) { create_expression_text("~eAz+") }

      it "returns the expected handled response" do
        expect(extract).to include(
          handled: true,
          token: an_object_having_attributes(text: "eAz"),
          next_expression_text: an_object_having_attributes(text: "+")
        )
      end
    end

    define_method(:create_expression_text) do |text|
      SymDiffer::ExpressionTextLanguageCompiler::ExpressionText.new(text)
    end
  end
end
