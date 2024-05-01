# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/sum_expression_reducer"
require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReduction::SumExpressionReducer do
  describe "#reduce" do
    subject(:reduce) do
      described_class
        .new(expression_factory, reducer)
        .reduce(expression)
    end

    before do
      allow(reducer)
        .to receive(:reduction_analysis)
        .with(expression_a)
        .and_return(reduced_expression: reduced_expression_a, sum_partition: sum_partition_a)

      allow(reducer)
        .to receive(:reduction_analysis)
        .with(expression_b)
        .and_return(reduced_expression: reduced_expression_a, sum_partition: sum_partition_b)
    end

    let(:expression) { sum_expression(expression_a, expression_b) }

    let(:reducer) { double(:reducer) }
    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    let(:reduced_expression_a) { double(:reduced_expression_a) }
    let(:reduced_expression_b) { double(:reduced_expression_b) }

    context "when the expression is 1 + 1" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(constant_expression(2)))
          .and_return(factor_partition: [2, nil])
      end

      let(:sum_partition_a) { [1, nil] }
      let(:sum_partition_b) { [1, nil] }

      it "returns the reduction results 2, [2, nil]" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(constant_expression(2)),
            sum_partition(2, nil),
            factor_partition(2, nil)
          )
        )
      end
    end

    context "when the expression is (1+1)+x" do
      let(:sum_partition_a) { [2, nil] }
      let(:sum_partition_b) { [0, variable_expression("x")] }

      it "returns the reduction results x + 2, [2, x]" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(sum_expression(variable_expression("x"), constant_expression(2))),
            sum_partition(2,
                          same_expression_as(variable_expression("x"))),
            factor_partition(1,
                             same_expression_as(sum_expression(variable_expression("x"), constant_expression(2))))
          )
        )
      end
    end

    context "when the expression is 1+(x+1)" do
      let(:sum_partition_a) { [0, variable_expression("x")] }
      let(:sum_partition_b) { [2, nil] }

      it "returns the reduction results x + 2, [2, x]" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(sum_expression(variable_expression("x"), constant_expression(2))),
            sum_partition(2,
                          same_expression_as(variable_expression("x"))),
            factor_partition(1,
                             same_expression_as(sum_expression(variable_expression("x"), constant_expression(2))))
          )
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

      let(:expected_sum_partition_subexpression) do
        sum_expression(variable_expression("x"), variable_expression("x"))
      end

      it "returns the reduction results x + 2, [2, x]" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(expected_reduced_expression),
            sum_partition(2, same_expression_as(expected_sum_partition_subexpression)),
            factor_partition(1, same_expression_as(expected_reduced_expression))
          )
        )
      end
    end

    context "when the expression is x+0" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(variable_expression("x")))
          .and_return(factor_partition: [1, variable_expression("x")])
      end

      let(:sum_partition_a) { [0, variable_expression("x")] }
      let(:sum_partition_b) { [0, nil] }

      it "returns the reduction results x, [0, x]" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(variable_expression("x")),
            sum_partition(0, same_expression_as(variable_expression("x"))),
            factor_partition(1, same_expression_as(variable_expression("x")))
          )
        )
      end
    end

    context "when the expression is 0+0" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(constant_expression(0)))
          .and_return(factor_partition: [0, nil])
      end

      let(:sum_partition_a) { [0, nil] }
      let(:sum_partition_b) { [0, nil] }

      it "returns the reduction results x, [0, x]" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(constant_expression(0)),
            sum_partition(0, nil),
            factor_partition(0, nil)
          )
        )
      end
    end

    context "when the expression is 1 + 2" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(constant_expression(3)))
          .and_return(factor_partition: [3, nil])
      end

      let(:sum_partition_a) { [1, nil] }
      let(:sum_partition_b) { [2, nil] }

      it "returns the reduction results 3, [3, nil]" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(constant_expression(3)),
            sum_partition(3, nil),
            factor_partition(3, nil)
          )
        )
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
end
