# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/nil_token_extractor"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::NilTokenExtractor do
  describe "#extract" do
    subject(:extract) do
      described_class.new.extract(expression_text)
    end

    context "when expression text is empty" do
      let(:expression_text) { "" }

      it { is_expected.to eq(handled: true, token: nil, next_expression_text: "") }
    end

    context "when expression text is x" do
      let(:expression_text) { "x" }

      it { is_expected.to eq(handled: false) }
    end
  end
end
