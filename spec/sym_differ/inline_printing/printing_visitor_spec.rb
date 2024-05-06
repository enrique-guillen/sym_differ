# frozen_string_literal: true

require "spec_helper"
require "sym_differ/inline_printing/printing_visitor"
require "sym_differ/expression_factory"

RSpec.describe SymDiffer::InlinePrinting::PrintingVisitor do
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
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: true))
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

    let(:printing_visitor) { described_class.new(parenthesize_infix_expressions_once:) }

    context "when the expression to stringify is exp_a + exp_b" do
      before do
        allow(expression_a)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: false))
          .and_return("exp_a")

        allow(expression_b)
          .to receive(:accept)
          .with(printing_visitor)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: false))
          .and_return("exp_b")
      end

      let(:expression) { sum_expression(expression_a, expression_b) }
      let(:expression_a) { double(:expression_a) }
      let(:expression_b) { double(:expression_b) }

      context "when parenthesize_infix_expressions_once=false" do
        let(:parenthesize_infix_expressions_once) { false }

        it { is_expected.to eq("exp_a + exp_b") }
      end

      context "when parenthesize_infix_expressions_once=true" do
        let(:parenthesize_infix_expressions_once) { true }

        it { is_expected.to eq("(exp_a + exp_b)") }
      end
    end

    context "when the expression to stringify is exp_a + exp_b + exp_c and parenthesize_infix_expressions_once=true" do
      before do
        allow(expression_a)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: false))
          .and_return("exp_a")

        allow(expression_b_1)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: false))
          .and_return("exp_b_1")

        allow(expression_b_2)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: false))
          .and_return("exp_b_2")
      end

      let(:parenthesize_infix_expressions_once) { true }

      let(:expression) { sum_expression(expression_a, sum_expression(expression_b_1, expression_b_2)) }
      let(:expression_a) { double(:expression_a) }
      let(:expression_b_1) { double(:expression_b_1) }
      let(:expression_b_2) { double(:expression_b_2) }

      it { is_expected.to eq("(exp_a + exp_b_1 + exp_b_2)") }
    end
  end

  describe "#visit_subtract_expression" do
    subject(:visit_subtract_expression) do
      printing_visitor.visit_subtract_expression(expression)
    end

    let(:printing_visitor) { described_class.new(parenthesize_infix_expressions_once:) }
    let(:parenthesize_infix_expressions_once) { false }

    context "when the subtrahend is an arbitrary expression" do
      before do
        allow(minuend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: false))
          .and_return("exp_a")

        allow(subtrahend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: true))
          .and_return("exp_b")
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it { is_expected.to eq("exp_a - exp_b") }
    end

    context "when the right hand expression (subtrahend) is another subtraction expression" do
      before do
        allow(minuend).to receive(:accept).with(printing_visitor).and_return("minuend")

        allow(right_minuend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: false))
          .and_return("right_minuend")

        allow(right_subtrahend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: true))
          .and_return("right_subtrahend")
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { double(:minuend) }
      let(:subtrahend) { subtract_expression(right_minuend, right_subtrahend) }

      let(:right_minuend) { double(:right_minuend) }
      let(:right_subtrahend) { double(:right_subtrahend) }

      it { is_expected.to eq("minuend - (right_minuend - right_subtrahend)") }
    end

    context "when the expression is <SubtractExpression:<SubTractExpression:<x, <SubtractExpression:<x,x>>>,<x>>" do
      before do
        allow(subtrahend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: true))
          .and_return("subtrahend")

        allow(left_minuend)
          .to receive(:accept)
          .with(printing_visitor)
          .and_return("left_minuend")

        allow(left_right_minuend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: false))
          .and_return("left_right_minuend")

        allow(left_right_subtrahend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: true))
          .and_return("left_right_subtrahend")
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { subtract_expression(left_minuend, left_subtrahend) }
      let(:subtrahend) { double(:subtrahend) }

      let(:left_minuend) { double(:left_minuend) }
      let(:left_subtrahend) { subtract_expression(left_right_minuend, left_right_subtrahend) }

      let(:left_right_minuend) { double(:left_right_minuend) }
      let(:left_right_subtrahend) { double(:left_right_subtrahend) }

      it { is_expected.to eq("left_minuend - (left_right_minuend - left_right_subtrahend) - subtrahend") }
    end

    context "when the expression to stringify is exp_a - exp_b - exp_c and parenthesize_infix_expressions_once=true" do
      before do
        allow(minuend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: false))
          .and_return("minuend")

        allow(subtrahend_1)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: false))
          .and_return("subtrahend_1")

        allow(subtrahend_2)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: true))
          .and_return("subtrahend_2")
      end

      let(:parenthesize_infix_expressions_once) { true }

      let(:expression) { subtract_expression(minuend, subtract_expression(subtrahend_1, subtrahend_2)) }
      let(:minuend) { double(:minuend) }
      let(:subtrahend_1) { double(:subtrahend_1) }
      let(:subtrahend_2) { double(:subtrahend_2) }

      it { is_expected.to eq("(minuend - (subtrahend_1 - subtrahend_2))") }
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
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: true))
          .and_return("multiplicand")

        allow(multiplier)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_infix_expressions_once: true))
          .and_return("multiplier")
      end

      let(:expression) { multiplicate_expression(multiplicand, multiplier) }

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it { is_expected.to eq("multiplicand * multiplier") }
    end
  end

  describe "#visit_derivative_expression" do
    subject(:visit_derivative_expression) do
      printing_visitor.visit_derivative_expression(expression)
    end

    before { allow(underived_expression).to receive(:accept).with(printing_visitor).and_return("exp") }

    let(:printing_visitor) { described_class.new }
    let(:expression) { derivative_expression(underived_expression, variable) }

    let(:underived_expression) { double(:underived_expression) }
    let(:variable) { variable_expression("var") }

    it { is_expected.to eq("derivative(exp, var)") }
  end

  describe "#visit_sine_expression" do
    subject(:visit_sine_expression) do
      printing_visitor.visit_sine_expression(expression)
    end

    before { allow(angle_expression).to receive(:accept).with(printing_visitor).and_return("exp") }

    let(:printing_visitor) { described_class.new }
    let(:expression) { sine_expression(angle_expression) }

    let(:angle_expression) { double(:underived_expression) }

    it { is_expected.to eq("sine(exp)") }
  end

  describe "#visit_cosine_expression" do
    subject(:visit_cosine_expression) do
      printing_visitor.visit_cosine_expression(expression)
    end

    before { allow(angle_expression).to receive(:accept).with(printing_visitor).and_return("exp") }

    let(:printing_visitor) { described_class.new }
    let(:expression) { cosine_expression(angle_expression) }

    let(:angle_expression) { double(:underived_expression) }

    it { is_expected.to eq("cosine(exp)") }
  end
end
