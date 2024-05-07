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

  describe "#extract_beginning_partition" do
    subject(:extract_beginning_partition) do
      stack.extract_beginning_partition(size)
    end

    context "when the stack is empty" do
      let(:stack) { described_class.new }

      context "when size 0 is passed" do
        let(:size) { 0 }

        it { is_expected.to eq([]) }
      end
    end

    context "when the stack is a" do
      let(:stack) { described_class.new(["a"]) }

      context "when size 1 is passed" do
        let(:size) { 1 }

        it { is_expected.to eq(["a"]) }
      end
    end

    context "when the stack is a, b" do
      let(:stack) { described_class.new(%w[a b]) }

      context "when size 1 is passed" do
        let(:size) { 1 }

        it { is_expected.to eq(["a"]) }
      end

      context "when size 2 is passed" do
        let(:size) { 2 }

        it { is_expected.to eq(%w[a b]) }
      end

      context "when size 3 is passed" do
        let(:size) { 3 }

        it { is_expected.to eq(%w[a b]) }
      end
    end
  end

  describe "#extract_tail_end_partition" do
    subject(:extract_tail_end_partition) do
      stack.extract_tail_end_partition(starting_index)
    end

    context "when stack is empty" do
      let(:stack) { described_class.new([]) }

      context "when starting_index is 0" do
        let(:starting_index) { 0 }

        it { is_expected.to eq([]) }
      end
    end

    context "when stack is a" do
      let(:stack) { described_class.new(["a"]) }

      context "when starting_index is 0" do
        let(:starting_index) { 0 }

        it { is_expected.to eq(["a"]) }
      end

      context "when starting_index is 1" do
        let(:starting_index) { 1 }

        it { is_expected.to eq([]) }
      end
    end

    context "when stack is a, b" do
      let(:stack) { described_class.new(%w[a b]) }

      context "when starting_index is 0" do
        let(:starting_index) { 0 }

        it { is_expected.to eq(%w[a b]) }
      end

      context "when starting_index is 1" do
        let(:starting_index) { 1 }

        it { is_expected.to eq(%w[b]) }
      end
    end
  end

  describe "#extract_stack_partition" do
    subject(:extract_stack_partition) do
      stack.extract_stack_partition(starting_index, size)
    end

    let(:stack) { described_class.new(%w[a b c d]) }
    let(:starting_index) { 1 }
    let(:size) { 2 }

    it { is_expected.to eq(%w[b c]) }
  end

  describe "#combine" do
    subject(:combine) do
      stack.combine(other_stack)
    end

    let(:stack) { described_class.new(%w[a b]) }
    let(:other_stack) { described_class.new(%w[c d]) }

    it { is_expected.to eq(%w[a b c d]) }
  end
end
