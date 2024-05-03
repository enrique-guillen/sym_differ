# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/positive_expression"
require "sym_differ/expressions/negate_expression"

RSpec.describe SymDiffer::Expressions::PositiveExpression do
  describe ".initialize" do
    subject(:expression) { described_class.new(summand) }

    let(:summand) { double(:summand) }

    it { is_expected.to have_attributes(summand:) }
  end

  describe "#accept" do
    subject(:accept) { positive_expression.accept(visitor) }

    before { allow(visitor).to receive(:visit_positive_expression) }

    let(:positive_expression) { described_class.new(summand) }
    let(:visitor) { double(:visitor) }
    let(:summand) { double(:summand) }

    it "emits visit_positive_expression command to the visitor" do
      accept
      expect(visitor).to have_received(:visit_positive_expression).with(positive_expression)
    end
  end

  describe "#same_as?" do
    subject(:same_as?) { expression.same_as?(other_expression) }

    let(:expression) { described_class.new(summand) }
    let(:summand) { expression_test_double(:summand) }

    context "when the provided expression has the same summand" do
      let(:other_expression) { described_class.new(summand) }

      it { is_expected.to be(true) }
    end

    context "when the provided expression has another summand" do
      before do
        allow(summand).to receive(:same_as?).with(other_summand).and_return(false)
      end

      let(:other_expression) { described_class.new(other_summand) }
      let(:other_summand) { double(:other_summand) }

      it { is_expected.to be(false) }
    end

    context "when the provided expression has another class" do
      let(:other_expression) { SymDiffer::Expressions::NegateExpression.new(summand) }

      it { is_expected.to be(false) }
    end
  end
end
