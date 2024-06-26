# frozen_string_literal: true

require "spec_helper"

require "sym_differ/expression_factory"
require "sym_differ/expressions/constant_expression"
require "sym_differ/expressions/variable_expression"
require "sym_differ/expressions/sum_expression"
require "sym_differ/expressions/subtract_expression"
require "sym_differ/expressions/negate_expression"
require "sym_differ/expressions/positive_expression"
require "sym_differ/expressions/sine_expression"
require "sym_differ/expressions/cosine_expression"
require "sym_differ/expressions/derivative_expression"
require "sym_differ/expressions/divide_expression"
require "sym_differ/expressions/exponentiate_expression"

RSpec.describe SymDiffer::ExpressionFactory do
  describe "#create_constant_expression" do
    subject(:create_constant_expression) do
      described_class.new.create_constant_expression(1)
    end

    it { is_expected.to be_a_kind_of(SymDiffer::Expressions::ConstantExpression).and have_attributes(value: 1) }
  end

  describe "#create_variable_expression" do
    subject(:create_variable_expression) do
      described_class.new.create_variable_expression("x")
    end

    it { is_expected.to be_a_kind_of(SymDiffer::Expressions::VariableExpression).and have_attributes(name: "x") }
  end

  describe "#create_sum_expression" do
    subject(:create_sum_expression) do
      described_class.new.create_sum_expression(expression_a, expression_b)
    end

    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    it "returns SumExpression" do
      expect(create_sum_expression)
        .to be_a_kind_of(SymDiffer::Expressions::SumExpression).and have_attributes(expression_a:, expression_b:)
    end
  end

  describe "#create_subtract_expression" do
    subject(:create_subtract_expression) do
      described_class.new.create_subtract_expression(minuend, subtrahend)
    end

    let(:minuend) { double(:minuend) }
    let(:subtrahend) { double(:subtrahend) }

    it "returns SubtractExpression" do
      expect(create_subtract_expression)
        .to be_a_kind_of(SymDiffer::Expressions::SubtractExpression).and have_attributes(minuend:, subtrahend:)
    end
  end

  describe "#create_negate_expression" do
    subject(:create_negate_expression) do
      described_class.new.create_negate_expression(negated_expression)
    end

    let(:negated_expression) { double(:negated_expression) }

    it "returns NegatedExpression" do
      expect(create_negate_expression)
        .to be_a_kind_of(SymDiffer::Expressions::NegateExpression).and have_attributes(negated_expression:)
    end
  end

  describe "#create_positive_expression" do
    subject(:create_positive_expression) do
      described_class.new.create_positive_expression(summand)
    end

    let(:summand) { double(:summand) }

    it { is_expected.to be_a_kind_of(SymDiffer::Expressions::PositiveExpression).and have_attributes(summand:) }
  end

  describe "#create_multiplicate_expression" do
    subject(:create_multiplicate_expression) do
      described_class.new.create_multiplicate_expression(multiplicand, multiplier)
    end

    let(:multiplicand) { double(:multiplicand) }
    let(:multiplier) { double(:multiplier) }

    it "returns a MultiplicateExpression" do
      expect(create_multiplicate_expression)
        .to be_a_kind_of(SymDiffer::Expressions::MultiplicateExpression)
        .and have_attributes(multiplicand:, multiplier:)
    end
  end

  describe "#create_sine_expression" do
    subject(:create_sine_expression) do
      described_class.new.create_sine_expression(angle_expression)
    end

    let(:angle_expression) { double(:angle_expression) }

    it "returns a SineExpression" do
      expect(create_sine_expression)
        .to be_a_kind_of(SymDiffer::Expressions::SineExpression)
        .and have_attributes(angle_expression:)
    end
  end

  describe "#create_cosine_expression" do
    subject(:create_cosine_expression) do
      described_class.new.create_cosine_expression(angle_expression)
    end

    let(:angle_expression) { double(:angle_expression) }

    it "returns a SineExpression" do
      expect(create_cosine_expression)
        .to be_a_kind_of(SymDiffer::Expressions::CosineExpression)
        .and have_attributes(angle_expression:)
    end
  end

  describe "#create_derivative_expression" do
    subject(:create_derivative_expression) do
      described_class.new.create_derivative_expression(underived_expression, variable)
    end

    let(:underived_expression) { double(:underived_expression) }
    let(:variable) { double(:variable) }

    it "returns a DerivativeExpression" do
      expect(create_derivative_expression)
        .to be_a_kind_of(SymDiffer::Expressions::DerivativeExpression)
        .and have_attributes(underived_expression:, variable:)
    end
  end

  describe "#create_divide_expression" do
    subject(:create_divide_expression) do
      described_class.new.create_divide_expression(numerator, denominator)
    end

    let(:numerator) { double(:numerator) }
    let(:denominator) { double(:denominator) }

    it "returns a DerivativeExpression" do
      expect(create_divide_expression)
        .to be_a_kind_of(SymDiffer::Expressions::DivideExpression)
        .and have_attributes(numerator:, denominator:)
    end
  end

  describe "#create_exponentiate_expression" do
    subject(:create_exponentiate_expression) do
      described_class.new.create_exponentiate_expression(base, power)
    end

    let(:base) { double(:base) }
    let(:power) { double(:power) }

    it "returns an ExponentiateExpression" do
      expect(create_exponentiate_expression)
        .to be_a_kind_of(SymDiffer::Expressions::ExponentiateExpression)
        .and have_attributes(base:, power:)
    end
  end

  describe "#create_natural_logarithm_expression" do
    subject(:create_natural_logarithm_expression) do
      described_class.new.create_natural_logarithm_expression(power)
    end

    let(:power) { double(:power) }

    it "returns a NaturalLogarithmExpression" do
      expect(create_natural_logarithm_expression)
        .to be_a_kind_of(SymDiffer::Expressions::NaturalLogarithmExpression)
        .and have_attributes(power:)
    end
  end

  describe "#create_euler_number_expression" do
    subject(:create_euler_number_expression) do
      described_class.new.create_euler_number_expression
    end

    it "returns an EulerNumberExpression" do
      expect(create_euler_number_expression)
        .to be_a_kind_of(SymDiffer::Expressions::EulerNumberExpression)
    end
  end

  describe "#constant_expression?" do
    subject(:constant_expression?) do
      factory.constant_expression?(expression)
    end

    let(:factory) { described_class.new }

    context "when the expression is x" do
      let(:expression) { factory.create_variable_expression("x") }

      it { is_expected.to be(false) }
    end

    context "when the expression is 1" do
      let(:expression) { factory.create_constant_expression(1) }

      it { is_expected.to be(true) }
    end
  end

  describe "#multiplicate_expression?" do
    subject(:multiplicate_expression?) do
      factory.multiplicate_expression?(expression)
    end

    let(:factory) { described_class.new }

    context "when the expression is 1" do
      let(:expression) { factory.create_constant_expression(1) }

      it { is_expected.to be(false) }
    end

    context "when the expression is x * y" do
      let(:expression) do
        factory.create_multiplicate_expression(
          factory.create_variable_expression("x"),
          factory.create_variable_expression("y")
        )
      end

      it { is_expected.to be(true) }
    end
  end

  describe "#exponentiate_expression?" do
    subject(:exponentiate_expression?) do
      factory.exponentiate_expression?(expression)
    end

    let(:factory) { described_class.new }

    context "when the expression is 1" do
      let(:expression) { factory.create_constant_expression(1) }

      it { is_expected.to be(false) }
    end

    context "when the expression is x ^ y" do
      let(:expression) do
        factory.create_exponentiate_expression(
          factory.create_variable_expression("x"),
          factory.create_variable_expression("y")
        )
      end

      it { is_expected.to be(true) }
    end
  end

  describe "#natural_logarithm_expression?" do
    subject(:natural_logarithm_expression?) do
      factory.natural_logarithm_expression?(expression)
    end

    let(:factory) { described_class.new }

    context "when the expression is 1" do
      let(:expression) { factory.create_constant_expression(1) }

      it { is_expected.to be(false) }
    end

    context "when the expression is ln(x)" do
      let(:expression) do
        factory.create_natural_logarithm_expression(
          factory.create_variable_expression("x")
        )
      end

      it { is_expected.to be(true) }
    end
  end
end
