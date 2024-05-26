# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/divide_expression"

RSpec.describe SymDiffer::Expressions::DivideExpression do
  describe "#initialize" do
    subject(:expression) do
      described_class.new(numerator, denominator)
    end

    let(:numerator) { double(:numerator) }
    let(:denominator) { double(:denominator) }

    it { is_expected.to have_attributes(numerator:, denominator:) }
  end

  describe "#accept" do
    subject(:accept) do
      expression.accept(visitor)
    end

    before do
      allow(visitor).to receive(:visit_divide_expression)
    end

    let(:expression) { described_class.new(numerator, denominator) }
    let(:visitor) { double(:visitor) }

    let(:numerator) { double(:numerator) }
    let(:denominator) { double(:denominator) }

    it "emits the visit_constant_expression call on the provided visitor" do
      accept
      expect(visitor).to have_received(:visit_divide_expression).with(expression)
    end
  end

  describe "#same_as?" do
    subject(:same_as?) do
      expression.same_as?(other_expression)
    end

    let(:expression_factory) { sym_differ_expression_factory }

    let(:expression) { described_class.new(numerator, denominator) }

    let(:numerator) { double(:numerator) }
    let(:denominator) { double(:denominator) }

    context "when other_expression = 1" do
      let(:other_expression) { constant_expression(1) }

      it { is_expected.to be(false) }
    end

    context "when other_expression = other_numerator/other_denominator" do
      let(:other_expression) { described_class.new(other_numerator, other_denominator) }

      let(:other_numerator) { double(:other_numerator) }
      let(:other_denominator) { double(:other_denominator) }

      context "when numerator != other_numerator" do
        before do
          allow(numerator)
            .to receive(:same_as?)
            .with(other_numerator)
            .and_return(false)
        end

        it { is_expected.to be(false) }
      end

      context "when denominator != other_denominator" do
        before do
          allow(numerator)
            .to receive(:same_as?)
            .with(other_numerator)
            .and_return(true)

          allow(denominator)
            .to receive(:same_as?)
            .with(other_denominator)
            .and_return(false)
        end

        it { is_expected.to be(false) }
      end
    end
  end
end
