# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/evaluation_stack"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::EvaluationStack do
  describe "#add_item_to_stack" do
    subject(:add_item_to_stack) do
      described_class.new.add_item_to_stack(1)
    end

    it { is_expected.to be_a_kind_of(described_class).and have_attributes(stack: [1]) }
  end

  describe "#last_item_in_stack" do
    subject(:last_item_in_stack) do
      stack.last_item_in_stack
    end

    context "when nothing has been pushed to the stack" do
      let(:stack) { described_class.new }

      it { is_expected.to be(nil) }
    end

    context "when the stack contains 1" do
      let(:stack) { described_class.new([0, 1]) }

      it { is_expected.to eq(1) }
    end
  end
end
