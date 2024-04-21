# frozen_string_literal: true

require "spec_helper"
require "sym_differ/inline_printing/printing_visitor"
require "sym_differ/expression_factory"

RSpec.describe SymDiffer::InlinePrinting::PrintingVisitor do
  let(:printing_visitor) { described_class.new }

  let(:expression_factory) { SymDiffer::ExpressionFactory.new }

  describe "#visit_constant_expression" do
    subject(:visit_constant_expression) do
      printing_visitor.visit_constant_expression(constant_expression(1))
    end

    it { is_expected.to eq("1") }
  end

  describe "#visit_variable_expression" do
    subject(:visit_variable_expression) do
      printing_visitor.visit_variable_expression(variable_expression("var"))
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

    let(:expression) { negate_expression(negated_expression) }
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

    let(:expression) { sum_expression(expression_a, expression_b) }
    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    it { is_expected.to eq("exp_a + exp_b") }
  end

  describe "#visit_subtract_expression" do
    subject(:visit_subtract_expression) do
      printing_visitor.visit_subtract_expression(expression)
    end

    context "when the subtrahend is an arbitrary expression" do
      let(:expression) { subtract_expression(minuend, subtrahend) }
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
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { double(:minuend) }
      let(:subtrahend) { subtract_expression(right_minuend, right_subtrahend) }

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
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { subtract_expression(left_minuend, left_subtrahend) }
      let(:subtrahend) { double(:subtrahend) }

      let(:left_minuend) { double(:left_minuend) }
      let(:left_subtrahend) { subtract_expression(left_right_minuend, left_right_subtrahend) }

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

  define_method(:constant_expression) do |value|
    expression_factory.create_constant_expression(value)
  end

  define_method(:variable_expression) do |name|
    expression_factory.create_variable_expression(name)
  end

  define_method(:sum_expression) do |expression_a, expression_b|
    expression_factory.create_sum_expression(expression_a, expression_b)
  end

  define_method(:subtract_expression) do |expression_a, expression_b|
    expression_factory.create_subtract_expression(expression_a, expression_b)
  end

  define_method(:negate_expression) do |negated_expression|
    expression_factory.create_negate_expression(negated_expression)
  end

  define_method(:positive_expression) do |summand|
    expression_factory.create_positive_expression(summand)
  end
end
