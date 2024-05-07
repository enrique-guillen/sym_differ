# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/evaluation_stack"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::EvaluationStack do
  describe "#add_item" do
    subject(:add_item) do
      described_class.new.add_item(1)
    end

    it { is_expected.to be_a_kind_of(described_class).and have_attributes(stack: [1]) }
  end

  describe "#last_item" do
    subject(:last_item) do
      stack.last_item
    end

    context "when nothing has been pushed to the stack" do
      let(:stack) { described_class.new }

      it { is_expected.to be_nil }
    end

    context "when the stack contains 1" do
      let(:stack) { described_class.new([0, 1]) }

      it { is_expected.to eq(1) }
    end
  end

  describe "#peek_item" do
    subject(:peek_item) do
      stack.peek_item(index)
    end

    context "when index is 1" do
      let(:index) { 1 }

      context "when nothing has been pushed to the stack" do
        let(:stack) { described_class.new }

        it { is_expected.to be_nil }
      end

      context "when the stack contains 1, 2, 3" do
        let(:stack) { described_class.new([1, 2, 3]) }

        it { is_expected.to eq(2) }
      end
    end

    context "when the index is negative and the stack is 1, 2, 3" do
      let(:index) { -1 }
      let(:stack) { described_class.new([1, 2, 3]) }

      it { is_expected.to be_nil }
    end
  end
end
