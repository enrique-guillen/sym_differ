# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/sum_expression"
require "sym_differ/expressions/constant_expression"

RSpec.describe SymDiffer::Expressions::SumExpression do
  describe "#initialize" do
    subject(:expression) { described_class.new(expression_a, expression_b) }

    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    it { is_expected.to have_attributes(expression_a:, expression_b:) }
  end

  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    before { allow(visitor).to receive(:visit_sum_expression) }

    let(:expression) { described_class.new(expression_a, expression_b) }
    let(:visitor) { double(:visitor) }
    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    it "emits the visit_sum_expression call on the provided visitor" do
      accept
      expect(visitor).to have_received(:visit_sum_expression).with(expression)
    end
  end

  describe "#same_as?" do
    subject(:same_as?) { expression.same_as?(other_expression) }

    let(:expression) { described_class.new(expression_a, expression_b) }
    let(:expression_a) { expression_test_double(:expression_a) }
    let(:expression_b) { expression_test_double(:expression_b) }

    context "when the other expression is a + b" do
      let(:other_expression) { described_class.new(expression_a, expression_b) }

      it { is_expected.to be(true) }
    end

    context "when the other expression is a + a" do
      before do
        allow(expression_b)
          .to receive(:same_as?)
          .with(expression_a)
          .and_return(false)
      end

      let(:other_expression) { described_class.new(expression_a, expression_a) }

      it { is_expected.to be(false) }
    end

    context "when the other expression is b + b" do
      before do
        allow(expression_a)
          .to receive(:same_as?)
          .with(expression_b)
          .and_return(false)
      end

      let(:other_expression) { described_class.new(expression_b, expression_b) }

      it { is_expected.to be(false) }
    end

    context "when the other expression is 1" do
      let(:other_expression) { SymDiffer::Expressions::ConstantExpression.new(1) }

      it { is_expected.to be(false) }
    end
  end
end
