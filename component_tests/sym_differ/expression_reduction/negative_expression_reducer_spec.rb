# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/negative_expression_reducer"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReduction::NegativeExpressionReducer do
  describe "#reduce" do
    subject(:reduce) do
      described_class
        .new(expression_factory, reducer)
        .reduce(expression)
    end

    let(:reducer) { double(:reducer) }
    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    context "when the expression is -1" do
      before do
        map_reduction_analysis(
          from: negated_expression,
          to: reduction_results(constant_expression(1), sum_partition(1, nil), factor_partition(1, nil))
        )
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(negate_expression(constant_expression(1))),
            sum_partition(-1, nil),
            factor_partition(-1, nil)
          )
        )
      end
    end

    context "when the expression is --1" do
      before do
        map_reduction_analysis(
          from: negated_expression,
          to: reduction_results(negate_expression(constant_expression(1)),
                                sum_partition(-1, nil),
                                factor_partition(-1, nil))
        )
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(constant_expression(1)),
            sum_partition(1, nil),
            factor_partition(1, nil)
          )
        )
      end
    end

    context "when the expression is -x" do
      before do
        map_reduction_analysis(
          from: negated_expression,
          to: reduction_results(variable_expression("x"),
                                sum_partition(0, variable_expression("x")),
                                factor_partition(1, variable_expression("x")))
        )
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(negate_expression(variable_expression("x"))),
            sum_partition(
              0, same_expression_as(negate_expression(variable_expression("x")))
            ),
            factor_partition(
              -1, same_expression_as(variable_expression("x"))
            )
          )
        )
      end
    end

    context "when the expression is --x" do
      before do
        map_reduction_analysis(
          from: negated_expression,
          to: reduction_results(negate_expression(variable_expression("x")),
                                sum_partition(0, negate_expression(variable_expression("x"))),
                                factor_partition(-1, variable_expression("x")))
        )
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(variable_expression("x")),
            sum_partition(0, same_expression_as(variable_expression("x"))),
            factor_partition(1, same_expression_as(variable_expression("x")))
          )
        )
      end
    end

    context "when the expression is -0 (clarify)" do
      before do
        map_reduction_analysis(
          from: negated_expression,
          to: reduction_results(constant_expression(0),
                                sum_partition(0, nil),
                                factor_partition(0, nil))
        )
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(constant_expression(0)),
            sum_partition(0, nil),
            factor_partition(0, nil)
          )
        )
      end
    end

    context "when the expression is -(2 * x)" do
      before do
        map_reduction_analysis(
          from: negated_expression,
          to: reduction_results(
            multiplicate_expression(constant_expression(2), variable_expression("x")),
            sum_partition(0, multiplicate_expression(constant_expression(2), variable_expression("x"))),
            factor_partition(2, variable_expression("x"))
          )
        )
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expected_reduced_expression =
          expected_sum_partition_subexpression =
            negate_expression(multiplicate_expression(constant_expression(2), variable_expression("x")))

        expected_factor_partition_subexpression = variable_expression("x")

        expect(reduce).to include(
          reduction_results(
            same_expression_as(expected_reduced_expression),
            sum_partition(0, same_expression_as(expected_sum_partition_subexpression)),
            factor_partition(-2, same_expression_as(expected_factor_partition_subexpression))
          )
        )
      end
    end

    context "when the expression is --(2 * x)" do
      before do
        map_reduction_analysis(
          from: negated_expression,
          to: reduction_results(
            negate_expression(multiplicate_expression(constant_expression(2), variable_expression("x"))),
            sum_partition(0,
                          negate_expression(multiplicate_expression(constant_expression(2), variable_expression("x")))),
            factor_partition(-2,
                             variable_expression("x"))
          )
        )
      end

      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expected_reduced_expression =
          expected_sum_partition_subexpression =
            multiplicate_expression(constant_expression(2), variable_expression("x"))

        expected_factor_partition_subexpression = variable_expression("x")

        expect(reduce).to include(
          reduction_results(
            same_expression_as(expected_reduced_expression),
            sum_partition(0, same_expression_as(expected_sum_partition_subexpression)),
            factor_partition(2, same_expression_as(expected_factor_partition_subexpression))
          )
        )
      end
    end

    define_method(:map_reduction_analysis) do |from:, to:, input: from, output: to|
      allow(reducer)
        .to receive(:reduction_analysis)
        .with(input)
        .and_return(output)
    end

    define_method(:reduction_results) do |reduced_expression, sum_partition, factor_partition = nil|
      { reduced_expression:, sum_partition:, factor_partition: }.compact
    end

    define_method(:sum_partition) do |constant, subexpression|
      [constant, subexpression]
    end

    define_method(:factor_partition) do |constant, subexpression|
      [constant, subexpression]
    end
  end
end
