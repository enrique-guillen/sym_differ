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

    before do
      allow(reducer)
        .to receive(:reduction_analysis)
        .with(negated_expression)
        .and_return(reduced_expression: reduced_negated_expression, sum_partition: negated_expression_sum_partition)
    end

    let(:reducer) { double(:reducer) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    let(:reduced_negated_expression) { double(:reduced_negated_expression) }

    let(:expression) { negate_expression(negated_expression) }

    context "when the expression is -1" do
      let(:negated_expression_sum_partition) { [1, nil] }

      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(negated_expression: an_object_having_attributes(value: 1)),
          sum_partition: [-1, nil]
        )
      end
    end

    context "when the expression is --1" do
      let(:negated_expression_sum_partition) { [-1, nil] }

      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(
            negated_expression: an_object_having_attributes(
              negated_expression: an_object_having_attributes(value: 1)
            )
          ),
          sum_partition: [1, nil],
          factor_partition: [-1, negated_expression]
        )
      end
    end

    context "when the expression is -x" do
      let(:negated_expression_sum_partition) { [0, reduced_negated_expression_sum_partition_subexpression] }

      let(:negated_expression) { double(:negated_expression) }

      let(:reduced_negated_expression_sum_partition_subexpression) do
        double(:reduced_negated_expression_sum_partition_subexpression)
      end

      it "returns the reductions of the negated expression" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(
            negated_expression: reduced_negated_expression_sum_partition_subexpression
          ),
          sum_partition: [
            0, an_object_having_attributes(negated_expression: reduced_negated_expression_sum_partition_subexpression)
          ]
        )
      end
    end

    context "when the expression is --x" do
      let(:negated_expression_sum_partition) do
        [0, negate_expression(reduced_negated_expression_sum_partition_subexpression)]
      end

      let(:negated_expression) { double(:negated_expression) }

      let(:reduced_negated_expression_sum_partition_subexpression) do
        double(:reduced_negated_expression_sum_partition_subexpression)
      end

      it "returns the reductions of the negated expression" do
        expect(reduce).to include(
          reduced_expression: reduced_negated_expression_sum_partition_subexpression,
          sum_partition: [0, reduced_negated_expression_sum_partition_subexpression]
        )
      end
    end

    context "when the expression is -0" do
      let(:negated_expression_sum_partition) { [0, nil] }

      let(:negated_expression) { double(:negated_expression) }

      it "returns the reductions of the negated expression" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(value: 0),
          sum_partition: [0, nil]
        )
      end
    end

    define_method(:negate_expression) do |negated_expression|
      expression_factory.create_negate_expression(negated_expression)
    end
  end
end
