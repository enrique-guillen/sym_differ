# frozen_string_literal: true

require "spec_helper"
require "sym_differ/stringifier_visitor"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::StringifierVisitor do
  let(:expression_factory) { SymDiffer::ExpressionFactory.new }

  describe "#visit_constant_expression" do
    subject(:visit_constant_expression) do
      printing_visitor.visit_constant_expression(constant_expression(1))
    end

    let(:printing_visitor) { described_class.new }

    it { is_expected.to eq("1") }
  end

  describe "#visit_variable_expression" do
    subject(:visit_variable_expression) do
      printing_visitor.visit_variable_expression(variable_expression("var"))
    end

    let(:printing_visitor) { described_class.new }

    it { is_expected.to eq("var") }
  end

  describe "#visit_negate_expression" do
    subject(:visit_negate_expression) do
      printing_visitor.visit_negate_expression(expression)
    end

    context "when the expression to negate is subexp" do
      before do
        allow(negated_expression)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions: true))
          .and_return("subexp")
      end

      let(:printing_visitor) { described_class.new }
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it { is_expected.to eq("-subexp") }
    end
  end

  describe "#visit_sum_expression" do
    subject(:visit_sum_expression) do
      printing_visitor.visit_sum_expression(expression)
    end

    let(:printing_visitor) { described_class.new(parenthesize_infix_expressions:) }

    context "when the expression to stringify is exp_a + exp_b" do
      before do
        allow(expression_a)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions: true))
          .and_return("exp_a")

        allow(expression_b)
          .to receive(:accept)
          .with(printing_visitor)
          .with(an_object_having_attributes(parenthesize_infix_expressions: true))
          .and_return("exp_b")
      end

      let(:expression) { sum_expression(expression_a, expression_b) }
      let(:expression_a) { double(:expression_a) }
      let(:expression_b) { double(:expression_b) }

      context "when parenthesize_infix_expressions=false" do
        let(:parenthesize_infix_expressions) { false }

        it { is_expected.to eq("exp_a + exp_b") }
      end

      context "when parenthesize_infix_expressions=true" do
        let(:parenthesize_infix_expressions) { true }

        it { is_expected.to eq("(exp_a + exp_b)") }
      end
    end
  end

  describe "#visit_subtract_expression" do
    subject(:visit_subtract_expression) do
      printing_visitor.visit_subtract_expression(expression)
    end

    before do
      allow(minuend)
        .to receive(:accept)
        .with(an_object_having_attributes(parenthesize_infix_expressions: true))
        .and_return("exp_a")

      allow(subtrahend)
        .to receive(:accept)
        .with(an_object_having_attributes(parenthesize_infix_expressions: true))
        .and_return("exp_b")
    end

    context "when the subtrahend is an arbitrary expression" do
      let(:printing_visitor) { described_class.new(parenthesize_infix_expressions: false) }

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it { is_expected.to eq("exp_a - exp_b") }
    end

    context "when parenthesize_infix_expressions: true" do
      let(:printing_visitor) { described_class.new(parenthesize_infix_expressions: true) }

      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it { is_expected.to eq("(exp_a - exp_b)") }
    end
  end

  describe "#visit_multiplicate_expression" do
    subject(:visit_multiplicate_expression) do
      printing_visitor.visit_multiplicate_expression(expression)
    end

    let(:printing_visitor) { described_class.new }

    context "when the expression is expa * expb" do
      before do
        allow(multiplicand)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions: true))
          .and_return("multiplicand")

        allow(multiplier)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions: true))
          .and_return("multiplier")
      end

      let(:expression) { multiplicate_expression(multiplicand, multiplier) }

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      context "when printing_visitor's parenthesize_infix_expressions flag is off" do
        let(:printing_visitor) { described_class.new }

        it { is_expected.to eq("multiplicand * multiplier") }
      end

      context "when printing_visitor's parenthesize_infix_expressions flag is on" do
        let(:printing_visitor) { described_class.new(parenthesize_infix_expressions: true) }

        it { is_expected.to eq("(multiplicand * multiplier)") }
      end
    end
  end

  describe "#visit_derivative_expression" do
    subject(:visit_derivative_expression) do
      printing_visitor.visit_derivative_expression(expression)
    end

    before do
      allow(underived_expression)
        .to receive(:accept)
        .with(an_object_having_attributes(parenthesize_infix_expressions: false))
        .and_return("exp")
    end

    let(:expression) { derivative_expression(underived_expression, variable) }

    let(:underived_expression) { double(:underived_expression) }
    let(:variable) { variable_expression("var") }

    context "when the parenthesize_infix_expressions flag is off" do
      let(:printing_visitor) { described_class.new }

      it { is_expected.to eq("derivative(exp, var)") }
    end

    context "when the parenthesize_infix_expressions flag is on" do
      let(:printing_visitor) { described_class.new(parenthesize_infix_expressions: true) }

      it { is_expected.to eq("derivative(exp, var)") }
    end
  end

  describe "#visit_sine_expression" do
    subject(:visit_sine_expression) do
      printing_visitor.visit_sine_expression(expression)
    end

    before do
      allow(angle_expression)
        .to receive(:accept)
        .with(an_object_having_attributes(parenthesize_infix_expressions: false))
        .and_return("exp")
    end

    let(:expression) { sine_expression(angle_expression) }

    let(:angle_expression) { double(:underived_expression) }

    context "when the parenthesize_infix_expressions flag is off" do
      let(:printing_visitor) { described_class.new }

      it { is_expected.to eq("sine(exp)") }
    end

    context "when the parenthesize_infix_expressions flag is on" do
      let(:printing_visitor) { described_class.new(parenthesize_infix_expressions: true) }

      it { is_expected.to eq("sine(exp)") }
    end
  end

  describe "#visit_cosine_expression" do
    subject(:visit_cosine_expression) do
      printing_visitor.visit_cosine_expression(expression)
    end

    before do
      allow(angle_expression)
        .to receive(:accept)
        .with(an_object_having_attributes(parenthesize_infix_expressions: false))
        .and_return("exp")
    end

    let(:expression) { cosine_expression(angle_expression) }

    let(:angle_expression) { double(:underived_expression) }

    context "when the parenthesize_infix_expressions flag is off" do
      let(:printing_visitor) { described_class.new }

      it { is_expected.to eq("cosine(exp)") }
    end

    context "when the parenthesize_infix_expressions flag is on" do
      let(:printing_visitor) { described_class.new(parenthesize_infix_expressions: true) }

      it { is_expected.to eq("cosine(exp)") }
    end
  end

  describe "#visit_divide_expression" do
    subject(:visit_divide_expression) do
      printing_visitor.visit_divide_expression(expression)
    end

    before do
      allow(numerator)
        .to receive(:accept)
        .with(an_object_having_attributes(parenthesize_infix_expressions: true))
        .and_return("num")

      allow(denominator)
        .to receive(:accept)
        .with(an_object_having_attributes(parenthesize_infix_expressions: true))
        .and_return("den")
    end

    let(:expression) { divide_expression(numerator, denominator) }

    let(:numerator) { double(:numerator) }
    let(:denominator) { double(:denominator) }

    context "when printing_visitor's parenthesize_infix_expressions flag is off" do
      let(:printing_visitor) { described_class.new }

      it { is_expected.to eq("num / den") }
    end

    context "when printing_visitor's parenthesize_infix_expressions flag is on" do
      let(:printing_visitor) { described_class.new(parenthesize_infix_expressions: true) }

      it { is_expected.to eq("(num / den)") }
    end
  end

  describe "#visit_exponentiate_expression" do
    subject(:visit_exponentiate_expression) do
      printing_visitor.visit_exponentiate_expression(expression)
    end

    before do
      allow(base)
        .to receive(:accept)
        .with(an_object_having_attributes(parenthesize_infix_expressions: true))
        .and_return("base")

      allow(power)
        .to receive(:accept)
        .with(an_object_having_attributes(parenthesize_infix_expressions: true))
        .and_return("power")
    end

    let(:expression) { exponentiate_expression(base, power) }
    let(:base) { double(:base) }
    let(:power) { double(:power) }

    context "when printing_visitor's parenthesize_infix_expressions flag is off" do
      let(:printing_visitor) { described_class.new }

      it { is_expected.to eq("base ^ power") }
    end

    context "when printing_visitor's parenthesize_infix_expressions flag is on" do
      let(:printing_visitor) { described_class.new(parenthesize_infix_expressions: true) }

      it { is_expected.to eq("(base ^ power)") }
    end
  end

  describe "#visit_positive_expression" do
    subject(:visit_positive_expression) do
      printing_visitor
        .visit_positive_expression(expression)
    end

    let(:printing_visitor) { described_class.new }

    context "when the provided expression is +subexp" do
      before do
        allow(summand)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions: true))
          .and_return("subexp")
      end

      let(:expression) { positive_expression(summand) }
      let(:summand) { double(:summand) }

      it { is_expected.to eq("+subexp") }
    end
  end
end
