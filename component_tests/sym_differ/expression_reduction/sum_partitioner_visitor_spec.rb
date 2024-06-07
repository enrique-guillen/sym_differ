# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/sum_partitioner_visitor"

require "sym_differ/expression_reduction/factor_partitioner_visitor"

RSpec.describe SymDiffer::ExpressionReduction::SumPartitionerVisitor do
  before do
    visitor.expression_reducer = expression_reducer
    visitor.factor_partitioner = factor_partitioner
  end

  let(:visitor) { described_class.new(expression_factory) }

  let(:expression_reducer) do
    SymDiffer::ExpressionReduction::ReducerVisitor
      .new(expression_factory, visitor, factor_partitioner)
  end

  let(:factor_partitioner) do
    SymDiffer::ExpressionReduction::FactorPartitionerVisitor
      .new(expression_factory, visitor)
  end

  let(:expression_factory) { sym_differ_expression_factory }

  describe "#partition" do
    subject(:partition) do
      visitor.partition(expression)
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

    it { is_expected.to match(sum_partition(1, nil)) }
  end

  describe "#visit_variable_expression" do
    subject(:visit_variable_expression) do
      visitor.visit_variable_expression(expression)
    end

    let(:expression) { variable_expression("x") }

    it { is_expected.to match(sum_partition(0, same_expression_as(variable_expression("x")))) }
  end

  describe "#visit_positive_expression" do
    subject(:visit_positive_expression) do
      visitor.visit_positive_expression(expression)
    end

    let(:expression) { positive_expression(variable_expression("x")) }

    it { is_expected.to match(sum_partition(0, same_expression_as(variable_expression("x")))) }
  end

  describe "#visit_negate_expression" do
    subject(:visit_negate_expression) do
      visitor.visit_negate_expression(expression)
    end

    let(:expression) { negate_expression(variable_expression("x")) }

    it { is_expected.to match(sum_partition(0, same_expression_as(negate_expression(variable_expression("x"))))) }
  end

  describe "#visit_sum_expression" do
    subject(:visit_sum_expression) do
      visitor.visit_sum_expression(expression)
    end

    let(:expression) { sum_expression(variable_expression("x"), variable_expression("x")) }

    it "returns the expected sum partition" do
      expect(visit_sum_expression).to match(
        sum_partition(
          0,
          same_expression_as(
            sum_expression(variable_expression("x"), variable_expression("x"))
          )
        )
      )
    end
  end

  describe "#visit_subtract_expression" do
    subject(:visit_subtract_expression) do
      visitor.visit_subtract_expression(expression)
    end

    let(:expression) { subtract_expression(variable_expression("x"), variable_expression("x")) }

    it "returns the expected subtract partition" do
      expect(visit_subtract_expression).to match(
        sum_partition(
          0,
          same_expression_as(
            subtract_expression(variable_expression("x"), variable_expression("x"))
          )
        )
      )
    end
  end

  describe "#visit_multiplicate_expression" do
    subject(:visit_multiplicate_expression) do
      visitor.visit_multiplicate_expression(expression)
    end

    let(:expression) { multiplicate_expression(variable_expression("x"), variable_expression("x")) }

    it "returns the expected multiplicate partition" do
      expect(visit_multiplicate_expression).to match(
        sum_partition(
          0,
          same_expression_as(
            multiplicate_expression(variable_expression("x"), variable_expression("x"))
          )
        )
      )
    end
  end

  describe "#visit_divide_expression" do
    subject(:visit_divide_expression) do
      visitor.visit_divide_expression(expression)
    end

    let(:expression) do
      divide_expression(variable_expression("x"), variable_expression("x"))
    end

    it "returns the expected multiplicate partition" do
      expect(visit_divide_expression).to match(
        sum_partition(
          0,
          same_expression_as(
            divide_expression(variable_expression("x"), variable_expression("x"))
          )
        )
      )
    end
  end

  describe "#visit_exponentiate_expression" do
    subject(:visit_exponentiate_expression) do
      visitor.visit_exponentiate_expression(expression)
    end

    let(:expression) do
      exponentiate_expression(variable_expression("x"), variable_expression("x"))
    end

    it "returns the expected multiplicate partition" do
      expect(visit_exponentiate_expression).to match(
        sum_partition(
          0,
          same_expression_as(
            exponentiate_expression(variable_expression("x"), variable_expression("x"))
          )
        )
      )
    end
  end

  define_method(:sum_partition) do |constant, subexpression|
    [constant, subexpression]
  end
end
