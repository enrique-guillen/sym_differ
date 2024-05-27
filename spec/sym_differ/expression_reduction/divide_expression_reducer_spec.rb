# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/divide_expression_reducer"

RSpec.describe SymDiffer::ExpressionReduction::DivideExpressionReducer do
  describe "#reduce" do
    subject(:reduce) do
      described_class
        .new(expression_factory, reducer)
        .reduce(expression)
    end

    let(:expression_factory) { sym_differ_expression_factory }
    let(:reducer) { double(:reducer) }

    context "when the expression is (1 + 1) / (2 + 2)" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(numerator)
          .and_return(reduced_expression: constant_expression(2))

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(denominator)
          .and_return(reduced_expression: constant_expression(4))
      end

      let(:expression) do
        divide_expression(numerator, denominator)
      end

      let(:numerator) { double(:numerator) }
      let(:denominator) { double(:denominator) }

      it "returns the reductions of the division expression" do
        reduced_expression = divide_expression(constant_expression(2), constant_expression(4))

        expect(reduce).to include(
          reduction_results(
            same_expression_as(reduced_expression),
            sum_partition(0, same_expression_as(reduced_expression)),
            factor_partition(1, same_expression_as(reduced_expression))
          )
        )
      end
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
