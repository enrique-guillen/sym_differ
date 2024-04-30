# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/variable_expression"
require "sym_differ/expressions/constant_expression"

RSpec.describe SymDiffer::Expressions::VariableExpression do
  describe "#initialize" do
    subject(:expression) { described_class.new("x") }

    it { is_expected.to have_attributes(name: "x") }
  end

  describe "#accept" do
    subject(:accept) do
      expression.accept(visitor)
    end

    before { allow(visitor).to receive(:visit_variable_expression) }

    let(:expression) { described_class.new("x") }
    let(:visitor) { double(:visitor) }

    it "emits the visit_variable_expression call on the visitor" do
      accept
      expect(visitor).to have_received(:visit_variable_expression).with(expression)
    end
  end

  describe "#same_as?" do
    subject(:same_as?) do
      expression.same_as?(other_expression)
    end

    let(:expression) { described_class.new("x") }

    context "when the other expression is x" do
      let(:other_expression) { described_class.new("x") }

      it { is_expected.to be(true) }
    end

    context "when the other expression is y" do
      let(:other_expression) { described_class.new("y") }

      it { is_expected.to be(false) }
    end

    context "when the other expression is 1" do
      let(:other_expression) { SymDiffer::Expressions::ConstantExpression.new(1) }

      it { is_expected.to be(false) }
    end
  end
end
