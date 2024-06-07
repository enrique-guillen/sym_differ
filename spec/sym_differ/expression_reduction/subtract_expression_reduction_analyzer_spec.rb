# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/subtract_expression_reduction_analyzer"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReduction::SubtractExpressionReductionAnalyzer do
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

    context "when the expression is 0-0" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([0, nil])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([0, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { constant_expression(0) }
      let(:subtrahend) { constant_expression(0) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce_expression).to be_same_as(constant_expression(0))
      end
    end

    context "when the expression is 1-0" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([1, nil])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([0, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce_expression).to be_same_as(constant_expression(1))
      end
    end

    context "when the expression is x-0" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([0, variable_expression("x")])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([0, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce_expression).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is 0-1" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([0, nil])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([1, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce_expression).to be_same_as(
          negate_expression(constant_expression(1))
        )
      end
    end

    context "when the expression is 0-x" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([0, nil])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([0, variable_expression("x")])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce_expression).to be_same_as(
          negate_expression(variable_expression("x"))
        )
      end
    end

    context "when the expression is (x+x)-1" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([0, sum_expression(variable_expression("x"), variable_expression("x"))])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([1, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce_expression).to be_same_as(
          subtract_expression(
            sum_expression(variable_expression("x"), variable_expression("x")),
            constant_expression(1)
          )
        )
      end
    end

    context "when the expression is x + 1 - (1-x)" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([1, variable_expression("x")])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([1, negate_expression(variable_expression("x"))])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce_expression).to be_same_as(
          sum_expression(
            variable_expression("x"), variable_expression("x")
          )
        )
      end
    end

    context "when the expression is 1+0-(0-1)" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([1, nil])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([-1, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce_expression).to be_same_as(
          constant_expression(2)
        )
      end
    end

    context "when the expression is 1 - x" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([1, nil])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([0, variable_expression("x")])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce_expression).to be_same_as(
          sum_expression(
            negate_expression(variable_expression("x")),
            constant_expression(1)
          )
        )
      end
    end

    context "when the expression is 0 - (0 -x)" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([0, nil])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([0, negate_expression(variable_expression("x"))])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce_expression).to be_same_as(variable_expression("x"))
      end
    end
  end

  describe "#make_factor_partition" do
    subject(:make_factor_partition) do
      reduction_analyzer.make_factor_partition(expression)
    end

    context "when the expression is x-1" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([0, variable_expression("x")])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([1, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it "returns the reductions of the subtraction expression" do
        expect(make_factor_partition).to match(
          [
            1,
            same_expression_as(
              subtract_expression(variable_expression("x"), constant_expression(1))
            )
          ]
        )
      end
    end

    context "when the expression is 0-1" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([0, nil])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([1, nil])

        allow(factor_partitioner)
          .to receive(:partition)
          .with(same_expression_as(negate_expression(constant_expression(1))))
          .and_return([-1, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it "returns the reductions of the subtraction expression" do
        expect(make_factor_partition).to match([-1, nil])
      end
    end
  end

  describe "#make_sum_partition" do
    subject(:make_sum_partition) do
      reduction_analyzer.make_sum_partition(expression)
    end

    context "when the expression is (x+x)-1" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(minuend)
          .and_return([0, sum_expression(variable_expression("x"), variable_expression("x"))])

        allow(sum_partitioner)
          .to receive(:partition)
          .with(subtrahend)
          .and_return([1, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it "returns the reductions of the subtraction expression" do
        expect(make_sum_partition).to match(
          [
            -1,
            same_expression_as(
              sum_expression(variable_expression("x"), variable_expression("x"))
            )
          ]
        )
      end
    end
  end

  define_method(:sum_partition) do |constant, subexpression|
    [constant, subexpression]
  end
end
