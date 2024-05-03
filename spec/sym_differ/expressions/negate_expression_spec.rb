# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/negate_expression"

require "sym_differ/expressions/positive_expression"

RSpec.describe SymDiffer::Expressions::NegateExpression do
  describe "#initialize" do
    subject(:expression) { described_class.new(negated_expression) }

    let(:negated_expression) { double(:expression) }

    it { is_expected.to have_attributes(negated_expression:) }
  end

  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    before { allow(visitor).to receive(:visit_negate_expression) }

    let(:visitor) { double(:visitor) }
    let(:expression) { described_class.new(negated_expression) }
    let(:negated_expression) { double(:expression) }

    it "emits the visit_negate_expression call on the provided visitor" do
      accept
      expect(visitor).to have_received(:visit_negate_expression).with(expression)
    end
  end

  describe "#same_as?" do
    subject(:same_as?) { expression.same_as?(other_expression) }

    let(:expression) { described_class.new(negated_expression) }
    let(:negated_expression) { expression_test_double(:negated_expression) }

    context "when the provided expression has the same summand" do
      let(:other_expression) { described_class.new(negated_expression) }

      it { is_expected.to be(true) }
    end

    context "when the provided expression has another summand" do
      before do
        allow(negated_expression)
          .to receive(:same_as?)
          .with(other_negated_expression)
          .and_return(false)
      end

      let(:other_expression) { described_class.new(other_negated_expression) }
      let(:other_negated_expression) { double(:other_negated_expression) }

      it { is_expected.to be(false) }
    end

    context "when the provided expression has another class" do
      let(:other_expression) { SymDiffer::Expressions::PositiveExpression.new(negated_expression) }

      it { is_expected.to be(false) }
    end
  end
end
