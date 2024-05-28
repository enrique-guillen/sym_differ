# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_evaluator_visitor"

RSpec.describe SymDiffer::ExpressionEvaluatorVisitor do
  let(:expression_factory) { sym_differ_expression_factory }

  describe "#evaluate" do
    subject(:evaluate) do
      described_class
        .new({})
        .evaluate(expression)
    end

    context "when the expression is 1/0" do
      let(:expression) { divide_expression(constant_expression(1), constant_expression(0)) }

      it { is_expected.to eq(:undefined) }
    end

    context "when the expression is 1/1" do
      let(:expression) { divide_expression(constant_expression(1), constant_expression(1)) }

      it { is_expected.to eq(Rational(1, 1)) }
    end
  end

  describe "#visit_constant_expression" do
    subject(:visit_constant_expression) do
      described_class
        .new({})
        .visit_constant_expression(expression)
    end

    let(:expression) { constant_expression(1) }

    it { is_expected.to eq(1) }
  end

  describe "#visit_variable_expression" do
    subject(:visit_variable_expression) do
      described_class
        .new(variable_values)
        .visit_variable_expression(expression)
    end

    let(:variable_values) { { "x" => 5 } }

    context "when expression is x (mapped to 5)" do
      let(:expression) { variable_expression("x") }

      it { is_expected.to eq(5) }
    end

    context "when expression is y (value not set)" do
      let(:expression) { variable_expression("y") }

      it { is_expected.to eq(0) }
    end
  end

  describe "#visit_sine_expression" do
    subject(:visit_sine_expression) do
      visitor.visit_sine_expression(expression)
    end

    before do
      allow(angle_expression)
        .to receive(:accept)
        .with(visitor)
        .and_return(1)
    end

    let(:visitor) { described_class.new(variable_values) }

    let(:expression) { sine_expression(angle_expression) }
    let(:variable_values) { { "x" => 5 } }
    let(:angle_expression) { double(:angle_expression) }

    it { is_expected.to eq(0.8414709848078965) }
  end

  describe "#visit_cosine_expression" do
    subject(:visit_cosine_expression) do
      visitor.visit_cosine_expression(expression)
    end

    before do
      allow(angle_expression)
        .to receive(:accept)
        .with(visitor)
        .and_return(1)
    end

    let(:visitor) { described_class.new(variable_values) }

    let(:expression) { cosine_expression(angle_expression) }
    let(:variable_values) { { "x" => 5 } }
    let(:angle_expression) { double(:angle_expression) }

    it { is_expected.to eq(0.5403023058681398) }
  end

  describe "#visit_negate_expression" do
    subject(:visit_negate_expression) do
      visitor.visit_negate_expression(expression)
    end

    before do
      allow(negated_expression)
        .to receive(:accept)
        .with(visitor)
        .and_return(5)
    end

    let(:visitor) { described_class.new(variable_values) }

    let(:expression) { negate_expression(negated_expression) }
    let(:variable_values) { { "x" => 5 } }
    let(:negated_expression) { double(:negated_expression) }

    it { is_expected.to eq(-5) }
  end

  describe "#visit_positive_expression" do
    subject(:visit_positive_expression) do
      visitor.visit_positive_expression(expression)
    end

    before do
      allow(summand)
        .to receive(:accept)
        .with(visitor)
        .and_return(5)
    end

    let(:visitor) { described_class.new(variable_values) }

    let(:expression) { positive_expression(summand) }
    let(:variable_values) { { "x" => 5 } }
    let(:summand) { double(:summand) }

    it { is_expected.to eq(5) }
  end

  describe "#visit_sum_expression" do
    subject(:visit_sum_expression) do
      visitor.visit_sum_expression(expression)
    end

    before do
      allow(expression_a)
        .to receive(:accept)
        .with(visitor)
        .and_return(5)

      allow(expression_b)
        .to receive(:accept)
        .with(visitor)
        .and_return(6)
    end

    let(:visitor) { described_class.new(variable_values) }

    let(:expression) { sum_expression(expression_a, expression_b) }
    let(:variable_values) { { "x" => 5 } }
    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    it { is_expected.to eq(11) }
  end

  describe "#visit_subtract_expression" do
    subject(:visit_subtract_expression) do
      visitor.visit_subtract_expression(expression)
    end

    before do
      allow(minuend)
        .to receive(:accept)
        .with(visitor)
        .and_return(5)

      allow(subtrahend)
        .to receive(:accept)
        .with(visitor)
        .and_return(6)
    end

    let(:visitor) { described_class.new(variable_values) }

    let(:expression) { subtract_expression(minuend, subtrahend) }
    let(:variable_values) { { "x" => 5 } }
    let(:minuend) { double(:minuend) }
    let(:subtrahend) { double(:subtrahend) }

    it { is_expected.to eq(-1) }
  end

  describe "#visit_multiplicate_expression" do
    subject(:visit_multiplicate_expression) do
      visitor.visit_multiplicate_expression(expression)
    end

    before do
      allow(multiplicand)
        .to receive(:accept)
        .with(visitor)
        .and_return(2)

      allow(multiplier)
        .to receive(:accept)
        .with(visitor)
        .and_return(3)
    end

    let(:visitor) { described_class.new(variable_values) }

    let(:expression) { multiplicate_expression(multiplicand, multiplier) }
    let(:variable_values) { { "x" => 5 } }
    let(:multiplicand) { double(:multiplicand) }
    let(:multiplier) { double(:multiplier) }

    it { is_expected.to eq(6) }
  end

  describe "#visit_divide_expression" do
    subject(:visit_divide_expression) do
      visitor.visit_divide_expression(expression)
    end

    before do
      allow(numerator)
        .to receive(:accept)
        .with(visitor)
        .and_return(2)

      allow(denominator)
        .to receive(:accept)
        .with(visitor)
        .and_return(3)
    end

    let(:visitor) { described_class.new(variable_values) }

    let(:expression) { divide_expression(numerator, denominator) }
    let(:variable_values) { { "x" => 5 } }
    let(:numerator) { double(:numerator) }
    let(:denominator) { double(:denominator) }

    it { is_expected.to eq(Rational(2, 3)) }
  end

  describe "#visit_exponentiate_expression" do
    subject(:visit_exponentiate_expression) do
      visitor.visit_exponentiate_expression(expression)
    end

    before do
      allow(base)
        .to receive(:accept)
        .with(visitor)
        .and_return(2)

      allow(power)
        .to receive(:accept)
        .with(visitor)
        .and_return(3)
    end

    let(:visitor) { described_class.new({}) }

    let(:expression) { exponentiate_expression(base, power) }
    let(:base) { double(:base) }
    let(:power) { double(:power) }

    it { is_expected }
  end
end
