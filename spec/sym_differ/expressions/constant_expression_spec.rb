# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/constant_expression"
require "sym_differ/expressions/variable_expression"

RSpec.describe SymDiffer::Expressions::ConstantExpression do
  describe "#initialize" do
    subject(:expression) { described_class.new(0) }

    it { is_expected.to have_attributes(value: 0) }
  end

  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    before { allow(visitor).to receive(:visit_constant_expression) }

    let(:expression) { described_class.new(0) }
    let(:visitor) { double(:visitor) }

    it "emits the visit_constant_expression call on the provided visitor" do
      accept
      expect(visitor).to have_received(:visit_constant_expression)
    end
  end

  describe "#same_as?" do
    subject(:same_as?) { expression.same_as?(other_expression) }

    let(:expression) { described_class.new(0) }

    context "when the other expression is 0" do
      let(:other_expression) { described_class.new(0) }

      it { is_expected.to be(true) }
    end

    context "when the other expression is 1" do
      let(:other_expression) { described_class.new(1) }

      it { is_expected.to be(false) }
    end

    context "when the other expression is x" do
      let(:other_expression) { SymDiffer::Expressions::VariableExpression.new("x") }

      it { is_expected.to be(false) }
    end
  end
end
