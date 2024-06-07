# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/reducer_visitor"

require "sym_differ/expression_reduction/sum_partitioner_visitor"
require "sym_differ/expression_reduction/factor_partitioner_visitor"

RSpec.describe SymDiffer::ExpressionReduction::ReducerVisitor do
  let(:visitor) do
    described_class.new(
      expression_factory,
      sum_partitioner_visitor,
      factor_partitioner_visitor
    )
  end

  let(:sum_partitioner_visitor) do
    SymDiffer::ExpressionReduction::SumPartitionerVisitor
      .new(expression_factory, factor_partitioner_visitor)
  end

  let(:factor_partitioner_visitor) { SymDiffer::ExpressionReduction::FactorPartitionerVisitor.new }

  let(:expression_factory) { sym_differ_expression_factory }

  describe "#reduce" do
    subject(:reduce) do
      visitor.reduce(expression)
    end

    before do
      allow(expression)
        .to receive(:accept)
        .with(visitor)
        .and_return(visit_result)
    end

    let(:expression) { double(:expression) }
    let(:visit_result) { double(:visit_result) }

    it { is_expected.to eq(visit_result) }
  end

  describe "#visit_constant_expression" do
    subject(:visit_constant_expression) do
      visitor.visit_constant_expression(expression)
    end

    let(:expression) { constant_expression(1) }

    it { is_expected.to be_same_as(constant_expression(1)) }
  end

  describe "#visit_variable_expression" do
    subject(:visit_variable_expression) do
      visitor.visit_variable_expression(expression)
    end

    let(:expression) { variable_expression("x") }

    it { is_expected.to be_same_as(variable_expression("x")) }
  end

  describe "#visit_positive_expression" do
    subject(:visit_positive_expression) do
      visitor.visit_positive_expression(expression)
    end

    let(:expression) { positive_expression(variable_expression("x")) }

    it { is_expected.to be_same_as(variable_expression("x")) }
  end

  describe "#visit_negate_expression" do
    subject(:visit_negate_expression) do
      visitor.visit_negate_expression(expression)
    end

    let(:expression) { negate_expression(variable_expression("x")) }

    it { is_expected.to be_same_as(negate_expression(variable_expression("x"))) }
  end

  describe "#visit_sum_expression" do
    subject(:visit_sum_expression) do
      visitor.visit_sum_expression(expression)
    end

    let(:expression) { sum_expression(constant_expression(1), constant_expression(1)) }

    it { is_expected.to be_same_as(constant_expression(2)) }
  end

  describe "#visit_subtract_expression" do
    subject(:visit_subtract_expression) do
      visitor.visit_subtract_expression(expression)
    end

    let(:expression) { subtract_expression(constant_expression(1), constant_expression(1)) }

    it { is_expected.to be_same_as(constant_expression(0)) }
  end

  describe "#visit_multiplicate_expression" do
    subject(:visit_multiplicate_expression) do
      visitor.visit_multiplicate_expression(expression)
    end

    let(:expression) { multiplicate_expression(constant_expression(2), constant_expression(2)) }

    it { is_expected.to be_same_as(constant_expression(4)) }
  end

  describe "#visit_divide_expression" do
    subject(:visit_divide_expression) do
      visitor.visit_divide_expression(expression)
    end

    let(:expression) { divide_expression(constant_expression(4), constant_expression(2)) }

    it { is_expected.to be_same_as(divide_expression(constant_expression(4), constant_expression(2))) }
  end

  describe "#visit_exponentiate_expression" do
    subject(:visit_exponentiate_expression) do
      visitor.visit_exponentiate_expression(expression)
    end

    let(:expression) { exponentiate_expression(constant_expression(4), constant_expression(2)) }

    it { is_expected.to be_same_as(exponentiate_expression(constant_expression(4), constant_expression(2))) }
  end
end
