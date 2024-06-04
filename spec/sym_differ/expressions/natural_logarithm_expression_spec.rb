# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/natural_logarithm_expression"

RSpec.describe SymDiffer::Expressions::NaturalLogarithmExpression do
  describe "#initialize" do
    subject(:expression) do
      described_class.new(power)
    end

    let(:power) { double(:power) }

    it { is_expected.to have_attributes(power:) }
  end

  describe "#accept" do
    subject(:accept) do
      expression.accept(visitor)
    end

    before { allow(visitor).to receive(:visit_natural_logarithm_expression) }

    let(:expression) { described_class.new(power) }
    let(:visitor) { double(:visitor) }

    let(:power) { double(:power) }

    it "emits the visit_natural_logarithm_expression call on the provided visitor" do
      accept
      expect(visitor).to have_received(:visit_natural_logarithm_expression).with(expression)
    end
  end

  describe "#same_as?" do
    subject(:same_as?) do
      expression.same_as?(other_expression)
    end

    let(:expression) { described_class.new(power) }
    let(:power) { double(:power) }

    context "when the other_expression = 1" do
      let(:other_expression) { constant_expression(1) }
      let(:expression_factory) { sym_differ_expression_factory }

      it { is_expected.to be(false) }
    end

    context "when the other_expression=ln(power)" do
      before do
        allow(power).to receive(:same_as?).with(power).and_return(true)
      end

      let(:other_expression) { described_class.new(power) }

      it { is_expected.to be(true) }
    end

    context "when the other_expression=ln(other_power)" do
      before do
        allow(other_power).to receive(:same_as?).with(power).and_return(false)
      end

      let(:other_expression) { described_class.new(other_power) }
      let(:other_power) { double(:other_power) }

      it { is_expected.to be(false) }
    end
  end
end
