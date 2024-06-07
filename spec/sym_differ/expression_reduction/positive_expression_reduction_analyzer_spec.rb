# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/positive_expression_reduction_analyzer"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReduction::PositiveExpressionReductionAnalyzer do
  let(:reduction_analyzer) do
    described_class.new(
      expression_reducer,
      sum_partitioner,
      factor_partitioner
    )
  end

  let(:expression_factory) { sym_differ_expression_factory }

  let(:expression_reducer) { double(:expression_reducer) }
  let(:sum_partitioner) { double(:sum_partitioner) }
  let(:factor_partitioner) { double(:factor_partitioner) }

  describe "#reduce_expression" do
    subject(:reduce_expression) do
      reduction_analyzer.reduce_expression(expression)
    end

    before do
      allow(expression_reducer)
        .to receive(:reduce)
        .with(summand)
        .and_return(reduced_summand)
    end

    let(:expression) { positive_expression(summand) }
    let(:summand) { double(:summand) }
    let(:reduced_summand) { double(:reduced_summand) }

    it "returns the reductions of the summand expression" do
      expect(reduce_expression).to eq(reduced_summand)
    end
  end

  describe "#make_sum_partition" do
    subject(:make_sum_partition) do
      reduction_analyzer.make_sum_partition(expression)
    end

    before do
      allow(sum_partitioner)
        .to receive(:partition)
        .with(summand)
        .and_return(sum_partition(5, reduced_summand))
    end

    let(:expression) { positive_expression(summand) }
    let(:summand) { double(:summand) }
    let(:reduced_summand) { double(:reduced_summand) }

    it "returns the reductions of the summand expression" do
      expect(make_sum_partition).to match(sum_partition(5, reduced_summand))
    end
  end

  describe "#make_factor_partition" do
    subject(:make_factor_partition) do
      reduction_analyzer.make_factor_partition(expression)
    end

    before do
      allow(factor_partitioner)
        .to receive(:partition)
        .with(summand)
        .and_return(factor_partition(2, reduced_summand))
    end

    let(:expression) { positive_expression(summand) }
    let(:summand) { double(:summand) }
    let(:reduced_summand) { double(:reduced_summand) }

    it "returns the reductions of the summand expression" do
      expect(make_factor_partition).to match(factor_partition(2, reduced_summand))
    end
  end

  define_method(:sum_partition) do |constant, subexpression|
    [constant, subexpression]
  end

  define_method(:factor_partition) do |constant, subexpression|
    [constant, subexpression]
  end
end
