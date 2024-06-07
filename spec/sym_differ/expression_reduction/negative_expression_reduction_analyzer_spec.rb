# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/negative_expression_reduction_analyzer"

RSpec.describe SymDiffer::ExpressionReduction::NegativeExpressionReductionAnalyzer do
  let(:reduction_analyzer) { described_class.new(expression_factory, sum_partitioner, factor_partitioner) }

  let(:expression_factory) { sym_differ_expression_factory }
  let(:sum_partitioner) { double(:sum_partitioner) }
  let(:factor_partitioner) { double(:factor_partitioner) }

  describe "#reduce_expression" do
    subject(:reduce_expression) do
      reduction_analyzer.reduce_expression(expression)
    end

    context "when the expression is -1" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(negated_expression)
          .and_return(factor_partition(1, nil))
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce_expression).to be_same_as(negate_expression(constant_expression(1)))
      end
    end

    context "when the expression is --1" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(negated_expression)
          .and_return(factor_partition(-1, nil))
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce_expression).to be_same_as(constant_expression(1))
      end
    end

    context "when the expression is -x" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(negated_expression)
          .and_return(factor_partition(1, variable_expression("x")))
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce_expression).to be_same_as(negate_expression(variable_expression("x")))
      end
    end

    context "when the expression is --x" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(negated_expression)
          .and_return(factor_partition(-1, variable_expression("x")))
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce_expression).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is -0 (clarify)" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(negated_expression)
          .and_return(factor_partition(0, nil))
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce_expression).to be_same_as(constant_expression(0))
      end
    end

    context "when the expression is -(2 * x)" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(negated_expression)
          .and_return(factor_partition(2, variable_expression("x")))
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce_expression).to be_same_as(
          negate_expression(
            multiplicate_expression(
              constant_expression(2),
              variable_expression("x")
            )
          )
        )
      end
    end

    context "when the expression is --(2 * x)" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(negated_expression)
          .and_return(factor_partition(-2, variable_expression("x")))
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce_expression).to be_same_as(
          multiplicate_expression(
            constant_expression(2), variable_expression("x")
          )
        )
      end
    end
  end

  describe "#make_sum_partition" do
    subject(:make_sum_partition) do
      reduction_analyzer.make_sum_partition(expression)
    end

    context "when the expression is -1" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(negated_expression)
          .and_return(sum_partition(1, nil))
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(make_sum_partition).to match(sum_partition(-1, nil))
      end
    end

    context "when the expression is --1" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(negated_expression)
          .and_return(sum_partition(-1, nil))
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(make_sum_partition).to match(sum_partition(1, nil))
      end
    end

    context "when the expression is --x" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(negated_expression)
          .and_return(sum_partition(0, negate_expression(variable_expression("x"))))
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(make_sum_partition).to match(
          sum_partition(
            0,
            same_expression_as(variable_expression("x"))
          )
        )
      end
    end

    context "when the expression is -(2 + x)" do
      before do
        allow(sum_partitioner)
          .to receive(:partition)
          .with(negated_expression)
          .and_return(sum_partition(2, variable_expression("x")))
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(make_sum_partition).to match(
          sum_partition(
            -2,
            same_expression_as(negate_expression(variable_expression("x")))
          )
        )
      end
    end
  end

  describe "#make_factor_partition" do
    subject(:make_factor_partition) do
      reduction_analyzer.make_factor_partition(expression)
    end

    context "when the expression is -1" do
      before do
        allow(factor_partitioner)
          .to receive(:partition)
          .with(negated_expression)
          .and_return(factor_partition(1, nil))
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(make_factor_partition).to match(factor_partition(-1, nil))
      end
    end
  end

  define_method(:sum_partition) do |constant, subexpression|
    [constant, subexpression]
  end

  define_method(:factor_partition) do |constant, subexpression|
    [constant, subexpression]
  end
end
