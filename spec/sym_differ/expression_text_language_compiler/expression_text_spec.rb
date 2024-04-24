# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/expression_text"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::ExpressionText do
  describe "#text" do
    subject(:text) { expression_text.text }

    before { expression_text.text = "x+1" }

    let(:expression_text) { described_class.new("") }

    it { expect(text).to eq("x+1") }
  end

  describe "#first_character_in_text" do
    subject(:first_character_in_text) do
      expression_text.first_character_in_text
    end

    let(:expression_text) { described_class.new("x+1") }

    it { expect(first_character_in_text).to eq("x") }
  end

  describe "#tail_end_of_text" do
    subject(:tail_end_of_text) do
      expression_text.tail_end_of_text
    end

    context "when the expression's text is x+1" do
      let(:expression_text) { described_class.new("x+1") }

      it { expect(tail_end_of_text).to eq("+1") }
    end

    context "when the expression's text is empty" do
      let(:expression_text) { described_class.new("") }

      it { expect(tail_end_of_text).to eq("") }
    end
  end
end
