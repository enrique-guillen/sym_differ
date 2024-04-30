# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/subtract_expression"

RSpec.describe SymDiffer::Expressions::SubtractExpression do
  describe ".new" do
    subject(:new) { described_class.new(minuend, subtrahend) }

    let(:minuend) { double(:minuend) }
    let(:subtrahend) { double(:subtrahend) }

    it { is_expected.to have_attributes(minuend:, subtrahend:) }
  end

  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    let(:expression) { described_class.new(minuend, subtrahend) }
    let(:visitor) { double(:visitor) }

    let(:minuend) { double(:minuend) }
    let(:subtrahend) { double(:subtrahend) }

    before { allow(visitor).to receive(:visit_subtract_expression) }

    it "emits the expected call to the provided visitor" do
      accept
      expect(visitor).to have_received(:visit_subtract_expression).with(expression)
    end
  end

  describe "#same_as?" do
    subject(:same_as?) { expression.same_as?(other_expression) }

    let(:expression) { described_class.new(expression_a, expression_b) }
    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    context "when the other expression is a - b" do
      before do
        allow(expression_a)
          .to receive(:same_as?)
          .with(expression_a)
          .and_return(true)

        allow(expression_b)
          .to receive(:same_as?)
          .with(expression_b)
          .and_return(true)
      end

      let(:other_expression) { described_class.new(expression_a, expression_b) }

      it { is_expected.to be(true) }
    end
  end
end
