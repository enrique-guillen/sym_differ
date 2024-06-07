# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/sum_expression_reduction_analyzer"

RSpec.describe SymDiffer::ExpressionReduction::SumExpressionReductionAnalyzer do
  let(:reduction_analyzer) do
    described_class.new(
      expression_factory,
      sum_partitioner,
      factor_partitioner
    )
  end

  let(:expression_factory) { sym_differ_expression_factory }
  let(:sum_partitioner) { double(:sum_partitioner) }
  let(:factor_partitioner) { double(:factor_partitioner) }

  describe "#reduce_expression" do
    subject(:reduce_expression) do
      reduction_analyzer.reduce_expression(expression)
    end

    before do
      allow(sum_partitioner)
        .to receive(:partition)
        .with(expression_a)
        .and_return(sum_partition_a)

      allow(sum_partitioner)
        .to receive(:partition)
        .with(expression_b)
        .and_return(sum_partition_b)
    end

    let(:expression) { sum_expression(expression_a, expression_b) }

    let(:expression_factory) { sym_differ_expression_factory }

    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    context "when the expression is 1 + 1" do
      let(:sum_partition_a) { [1, nil] }
      let(:sum_partition_b) { [1, nil] }

      it "returns the reduction results 2, [2, nil]" do
        expect(reduce_expression).to be_same_as(constant_expression(2))
      end
    end

    context "when the expression is (1+1)+x" do
      let(:sum_partition_a) { [2, nil] }
      let(:sum_partition_b) { [0, variable_expression("x")] }

      it "returns the reduction results x + 2, [2, x]" do
        expect(reduce_expression).to be_same_as(
          sum_expression(variable_expression("x"), constant_expression(2))
        )
      end
    end

    context "when the expression is 1+(x+1)" do
      let(:sum_partition_a) { [0, variable_expression("x")] }
      let(:sum_partition_b) { [2, nil] }

      it "returns the reduction results x + 2, [2, x]" do
        expect(reduce_expression).to be_same_as(
          sum_expression(variable_expression("x"), constant_expression(2))
        )
      end
    end

    context "when the expression is (x + 1) + (x + 1)" do
      let(:sum_partition_a) { [1, variable_expression("x")] }
      let(:sum_partition_b) { [1, variable_expression("x")] }

      let(:expected_reduced_expression) do
        sum_expression(
          sum_expression(variable_expression("x"), variable_expression("x")),
          constant_expression(2)
        )
      end

      it "returns the reduction results x + 2, [2, x]" do
        expect(reduce_expression).to be_same_as(
          sum_expression(
            sum_expression(variable_expression("x"), variable_expression("x")),
            constant_expression(2)
          )
        )
      end
    end

    context "when the expression is x+0" do
      let(:sum_partition_a) { [0, variable_expression("x")] }
      let(:sum_partition_b) { [0, nil] }

      it "returns the reduction results x, [0, x]" do
        expect(reduce_expression).to be_same_as(
          variable_expression("x")
        )
      end
    end

    context "when the expression is 0+0" do
      let(:sum_partition_a) { [0, nil] }
      let(:sum_partition_b) { [0, nil] }

      it "returns the reduction results x, [0, x]" do
        expect(reduce_expression).to be_same_as(constant_expression(0))
      end
    end
  end

  describe "#make_factor_partition" do
    subject(:make_factor_partition) do
      reduction_analyzer.make_factor_partition(expression)
    end

    before do
      allow(sum_partitioner)
        .to receive(:partition)
        .with(expression_a)
        .and_return(sum_partition_a)

      allow(sum_partitioner)
        .to receive(:partition)
        .with(expression_b)
        .and_return(sum_partition_b)
    end

    let(:expression) { sum_expression(expression_a, expression_b) }

    let(:expression_factory) { sym_differ_expression_factory }

    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    context "when the expression is 2+x" do
      let(:sum_partition_a) { [2, nil] }
      let(:sum_partition_b) { [0, variable_expression("x")] }

      it "returns the reduction results x + 2, [2, x]" do
        expect(make_factor_partition).to match(
          factor_partition(
            1,
            same_expression_as(sum_expression(variable_expression("x"), constant_expression(2)))
          )
        )
      end
    end

    context "when the expression is 1 + 2" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(same_expression_as(constant_expression(3)))
          .and_return(factor_partition(3, nil))
      end

      let(:sum_partition_a) { [1, nil] }
      let(:sum_partition_b) { [2, nil] }

      it "returns the reduction results 3, [3, nil]" do
        expect(make_factor_partition).to match(factor_partition(3, nil))
      end
    end
  end

  describe "#make_sum_partition" do
    subject(:make_sum_partition) do
      reduction_analyzer.make_sum_partition(expression)
    end

    before do
      allow(sum_partitioner)
        .to receive(:partition)
        .with(expression_a)
        .and_return(sum_partition_a)

      allow(sum_partitioner)
        .to receive(:partition)
        .with(expression_b)
        .and_return(sum_partition_b)
    end

    let(:expression) { sum_expression(expression_a, expression_b) }

    let(:expression_factory) { sym_differ_expression_factory }

    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    context "when the expression is 2+x" do
      let(:sum_partition_a) { [2, nil] }
      let(:sum_partition_b) { [0, variable_expression("x")] }

      it "returns the reduction results x + 2, [2, x]" do
        expect(make_sum_partition).to match(
          sum_partition(2, same_expression_as(variable_expression("x")))
        )
      end
    end
  end

  define_method(:reduction_results) do |reduced_expression, sum_partition, factor_partition|
    { reduced_expression:, sum_partition:, factor_partition: }
  end

  define_method(:sum_partition) do |constant, subexpression|
    [constant, subexpression]
  end

  define_method(:factor_partition) do |constant, subexpression|
    [constant, subexpression]
  end
end
