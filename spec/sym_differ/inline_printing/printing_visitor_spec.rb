# frozen_string_literal: true

require "spec_helper"
require "sym_differ/inline_printing/printing_visitor"
require "sym_differ/constant_expression"

RSpec.describe SymDiffer::InlinePrinting::PrintingVisitor do
  let(:printing_visitor) { described_class.new }

  describe "#visit_constant_expression" do
    subject(:visit_constant_expression) do
      printing_visitor.visit_constant_expression(SymDiffer::ConstantExpression.new(1))
    end

    it { is_expected.to eq("1") }
  end

  describe "#visit_variable_expression" do
    subject(:visit_variable_expression) do
      printing_visitor.visit_variable_expression(SymDiffer::VariableExpression.new("var"))
    end

    it { is_expected.to eq("var") }
  end

  describe "#visit_negate_expression" do
    subject(:visit_negate_expression) do
      printing_visitor.visit_negate_expression(expression)
    end

    before do
      allow(negated_expression)
        .to receive(:accept)
        .with(printing_visitor)
        .and_return("subexp")
    end

    let(:expression) { SymDiffer::NegateExpression.new(negated_expression) }
    let(:negated_expression) { double(:negated_expression) }

    it { is_expected.to eq("-subexp") }
  end

  describe "#visit_sum_expression" do
    subject(:visit_sum_expression) do
      printing_visitor.visit_sum_expression(expression)
    end

    before do
      allow(expression_a)
        .to receive(:accept)
        .with(printing_visitor)
        .and_return("exp_a")

      allow(expression_b)
        .to receive(:accept)
        .with(printing_visitor)
        .and_return("exp_b")
    end

    let(:expression) { SymDiffer::SumExpression.new(expression_a, expression_b) }
    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    it { is_expected.to eq("exp_a + exp_b") }
  end

  describe "#visit_subtract_expression" do
    subject(:visit_subtract_expression) do
      printing_visitor.visit_subtract_expression(expression)
    end

    context "when the subtrahend is an arbitrary expression" do
      let(:expression) { SymDiffer::SubtractExpression.new(minuend, subtrahend) }
      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      before do
        allow(minuend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_subtraction_expressions: false))
          .and_return("exp_a")

        allow(subtrahend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_subtraction_expressions: true))
          .and_return("exp_b")
      end

      it { is_expected.to eq("exp_a - exp_b") }
    end

    context "when the right hand expression (subtrahend) is another subtraction expression" do
      let(:expression) { SymDiffer::SubtractExpression.new(minuend, subtrahend) }

      let(:minuend) { double(:minuend) }
      let(:subtrahend) { SymDiffer::SubtractExpression.new(right_minuend, right_subtrahend) }

      let(:right_minuend) { double(:right_minuend) }
      let(:right_subtrahend) { double(:right_subtrahend) }

      before do
        allow(minuend).to receive(:accept).with(printing_visitor).and_return("minuend")

        allow(right_minuend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_subtraction_expressions: true))
          .and_return("right_minuend")

        allow(right_subtrahend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_subtraction_expressions: true))
          .and_return("right_subtrahend")
      end

      it { is_expected.to eq("minuend - (right_minuend - right_subtrahend)") }
    end

    context "when the expression is <SubtractExpression:<SubTractExpression:<x, <SubtractExpression:<x,x>>>,<x>>" do
      let(:expression) { SymDiffer::SubtractExpression.new(minuend, subtrahend) }

      let(:minuend) { SymDiffer::SubtractExpression.new(left_minuend, left_subtrahend) }
      let(:subtrahend) { double(:subtrahend) }

      let(:left_minuend) { double(:left_minuend) }
      let(:left_subtrahend) { SymDiffer::SubtractExpression.new(left_right_minuend, left_right_subtrahend) }

      let(:left_right_minuend) { double(:left_right_minuend) }
      let(:left_right_subtrahend) { double(:left_right_subtrahend) }

      before do
        allow(subtrahend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_subtraction_expressions: true))
          .and_return("subtrahend")

        allow(left_minuend).to receive(:accept).with(printing_visitor).and_return("left_minuend")

        allow(left_right_minuend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_subtraction_expressions: true))
          .and_return("left_right_minuend")

        allow(left_right_subtrahend)
          .to receive(:accept)
          .with(an_object_having_attributes(parenthesize_subtraction_expressions: true))
          .and_return("left_right_subtrahend")
      end

      it { is_expected.to eq("left_minuend - (left_right_minuend - left_right_subtrahend) - subtrahend") }
    end
  end
end
