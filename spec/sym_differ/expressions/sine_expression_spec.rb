# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/sine_expression"

RSpec.describe SymDiffer::Expressions::SineExpression do
  describe "#initialize" do
    subject(:expression) do
      described_class.new(angle_expression)
    end

    let(:angle_expression) { double(:angle_expression) }

    it { is_expected.to have_attributes(angle_expression:) }
  end

  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    before { allow(visitor).to receive(:visit_sine_expression) }

    let(:expression) { described_class.new(angle_expression) }

    let(:visitor) { double(:visitor) }

    let(:angle_expression) { double(:angle_expression) }

    it "emits the call to the corresponding visitor method" do
      accept
      expect(visitor).to have_received(:visit_sine_expression).with(expression)
    end
  end

  describe "#same_as?" do
    subject(:same_as?) { expression.same_as?(other_expression) }

    let(:expression) { described_class.new(angle_expression) }
    let(:angle_expression) { expression_test_double(:angle_expression) }

    let(:expression_factory) { sym_differ_expression_factory }

    context "when other_expression=sine(same_angle_expression)" do
      let(:other_expression) { described_class.new(angle_expression) }

      it { is_expected.to be(true) }
    end

    context "when other_expression=sine(different_angle_expression)" do
      let(:other_expression) { described_class.new(other_angle_expression) }
      let(:other_angle_expression) { double(:other_angle_expression) }

      it { is_expected.to be(false) }
    end

    context "when other_expression=otherfunctiontype" do
      let(:other_expression) { variable_expression("x") }

      it { is_expected.to be(false) }
    end
  end
end
