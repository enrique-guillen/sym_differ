# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/exponentiate_expression"

RSpec.describe SymDiffer::Expressions::ExponentiateExpression do
  describe "#initialize" do
    subject(:expression) do
      described_class.new(base, power)
    end

    let(:base) { double(:base) }
    let(:power) { double(:power) }

    it { is_expected.to have_attributes(base:, power:) }
  end

  describe "#accept" do
    subject(:accept) do
      expression.accept(visitor)
    end

    before do
      allow(visitor).to receive(:visit_exponentiate_expression)
    end

    let(:expression) { described_class.new(base, power) }
    let(:visitor) { double(:visitor) }

    let(:base) { double(:base) }
    let(:power) { double(:power) }

    it "emits the visit_constant_expression call on the provided visitor" do
      accept
      expect(visitor).to have_received(:visit_exponentiate_expression).with(expression)
    end
  end

  describe "#same_as?" do
    subject(:same_as?) do
      expression.same_as?(other_expression)
    end

    let(:expression_factory) { sym_differ_expression_factory }

    let(:expression) { described_class.new(base, power) }

    let(:base) { double(:base) }
    let(:power) { double(:power) }

    context "when other_expression = 1" do
      let(:other_expression) { constant_expression(1) }

      it { is_expected.to be(false) }
    end

    context "when other_expression = Exponentiate(other_base, other_power)" do
      let(:other_expression) { described_class.new(other_base, other_power) }

      let(:other_base) { double(:other_base) }
      let(:other_power) { double(:other_power) }

      context "when other_base!=base" do
        before do
          allow(base)
            .to receive(:same_as?)
            .with(other_base)
            .and_return(false)
        end

        it { is_expected.to be(false) }
      end

      context "when other_power!=power" do
        before do
          allow(base)
            .to receive(:same_as?)
            .with(other_base)
            .and_return(true)

          allow(power)
            .to receive(:same_as?)
            .with(other_power)
            .and_return(false)
        end

        it { is_expected.to be(false) }
      end

      context "when both other_base=base and other_power=power" do
        before do
          allow(base)
            .to receive(:same_as?)
            .with(other_base)
            .and_return(true)

          allow(power)
            .to receive(:same_as?)
            .with(other_power)
            .and_return(true)
        end

        it { is_expected.to be(true) }
      end
    end
  end
end
