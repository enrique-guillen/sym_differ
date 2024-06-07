# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/multiplicate_expression_reduction_analyzer"

RSpec.describe SymDiffer::ExpressionReduction::MultiplicateExpressionReductionAnalyzer do
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

    context "when the expression is x*x" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplicand)
          .and_return(factor_partition(1, variable_expression("x")))

        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplier)
          .and_return(factor_partition(1, variable_expression("x")))
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results x * x, [0, x * x]" do
        expected_reduced_expression = multiplicate_expression(variable_expression("x"), variable_expression("x"))

        expect(reduce_expression).to be_same_as(expected_reduced_expression)
      end
    end

    context "when the expression is 2*2" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplicand)
          .and_return(factor_partition(2, nil))

        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplier)
          .and_return(factor_partition(2, nil))
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results 4, [4, nil], [4, nil]" do
        expect(reduce_expression).to be_same_as(constant_expression(4))
      end
    end

    context "when the expression is x * 1" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplicand)
          .and_return(factor_partition(1, variable_expression("x")))

        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplier)
          .and_return(factor_partition(1, nil))
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results x, [0, x]" do
        expect(reduce_expression).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is 1 * x" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplicand)
          .and_return(factor_partition(1, nil))

        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplier)
          .and_return(factor_partition(1, variable_expression("x")))
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results x, [0, x]" do
        expect(reduce_expression).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is x * 0" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplicand)
          .and_return(factor_partition(1, variable_expression("x")))

        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplier)
          .and_return(factor_partition(0, nil))
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results 0, [0, 0]" do
        expect(reduce_expression).to be_same_as(constant_expression(0))
      end
    end

    context "when the expression is 3x * 3" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplicand)
          .and_return(factor_partition(3, variable_expression("x")))

        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplier)
          .and_return(factor_partition(3, nil))
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results 9x, [0, 9x], [9, x]" do
        expect(reduce_expression).to be_same_as(
          multiplicate_expression(constant_expression(9), variable_expression("x"))
        )
      end
    end
  end

  describe "#make_factor_partition" do
    subject(:make_factor_partition) do
      reduction_analyzer.make_factor_partition(expression)
    end

    context "when the expression is 3x * 3" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplicand)
          .and_return(factor_partition(3, variable_expression("x")))

        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplier)
          .and_return(factor_partition(3, nil))
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results 9x, [0, 9x], [9, x]" do
        expected_factor_partition_subexpression = variable_expression("x")

        expect(make_factor_partition).to match(
          factor_partition(9, same_expression_as(expected_factor_partition_subexpression))
        )
      end
    end
  end

  describe "#make_sum_partition" do
    subject(:make_sum_partition) do
      reduction_analyzer.make_sum_partition(expression)
    end

    context "when the expression is 3x * 3" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplicand)
          .and_return(factor_partition(3, variable_expression("x")))

        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplier)
          .and_return(factor_partition(3, nil))
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results 9x, [0, 9x], [9, x]" do
        expected_sum_partition_subexpression =
          multiplicate_expression(constant_expression(9), variable_expression("x"))

        expect(make_sum_partition).to match(
          sum_partition(0, same_expression_as(expected_sum_partition_subexpression))
        )
      end
    end

    context "when the expression is 2*2" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplicand)
          .and_return(factor_partition(2, nil))

        allow(factor_partitioner)
          .to receive(:partition)
          .with(multiplier)
          .and_return(factor_partition(2, nil))

        allow(sum_partitioner)
          .to receive(:partition)
          .with(same_expression_as(constant_expression(4)))
          .and_return(sum_partition(4, nil))
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the expected sum partition" do
        expect(make_sum_partition).to match(sum_partition(4, nil))
      end
    end
  end

  define_method(:factor_partition) do |constant, subexpression|
    [constant, subexpression]
  end

  define_method(:sum_partition) do |constant, subexpression|
    [constant, subexpression]
  end
end
