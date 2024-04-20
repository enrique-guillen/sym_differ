# frozen_string_literal: true

require "spec_helper"

require "sym_differ/expression_factory"
require "sym_differ/constant_expression"
require "sym_differ/variable_expression"
require "sym_differ/sum_expression"
require "sym_differ/subtract_expression"
require "sym_differ/negate_expression"

RSpec.describe SymDiffer::ExpressionFactory do
  describe "#create_constant_expression" do
    subject(:create_constant_expression) do
      described_class.new.create_constant_expression(1)
    end

    it { is_expected.to be_a_kind_of(SymDiffer::ConstantExpression).and have_attributes(value: 1) }
  end

  describe "#create_variable_expression" do
    subject(:create_variable_expression) do
      described_class.new.create_variable_expression("x")
    end

    it { is_expected.to be_a_kind_of(SymDiffer::VariableExpression).and have_attributes(name: "x") }
  end

  describe "#create_sum_expression" do
    subject(:create_sum_expression) do
      described_class.new.create_sum_expression(expression_a, expression_b)
    end

    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    it { is_expected.to be_a_kind_of(SymDiffer::SumExpression).and have_attributes(expression_a:, expression_b:) }
  end

  describe "#create_subtract_expression" do
    subject(:create_subtract_expression) do
      described_class.new.create_subtract_expression(minuend, subtrahend)
    end

    let(:minuend) { double(:minuend) }
    let(:subtrahend) { double(:subtrahend) }

    it { is_expected.to be_a_kind_of(SymDiffer::SubtractExpression).and have_attributes(minuend:, subtrahend:) }
  end

  describe "#create_negate_expression" do
    subject(:create_negate_expression) do
      described_class.new.create_negate_expression(negated_expression)
    end

    let(:negated_expression) { double(:negated_expression) }

    it { is_expected.to be_a_kind_of(SymDiffer::NegateExpression).and have_attributes(negated_expression:) }
  end
end