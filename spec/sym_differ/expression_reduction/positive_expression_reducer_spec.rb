# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/positive_expression_reducer"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReduction::PositiveExpressionReducer do
  describe "#reduce" do
    subject(:reduce) { described_class.new(reducer).reduce(expression) }

    before do
      allow(reducer)
        .to receive(:reduction_analysis)
        .with(summand)
        .and_return(reduced_expression: reduced_summand,
                    sum_partition: [5, reduced_summand_sum_partition_subexpression],
                    factor_partition: [2, reduced_summand_factor_partition_subexpression])
    end

    let(:reducer) { double(:reducer) }

    let(:expression) { expression_factory.create_positive_expression(summand) }
    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    let(:summand) { double(:summand) }

    let(:reduced_summand) { double(:reduced_summand) }
    let(:reduced_summand_sum_partition_subexpression) { double(:reduced_summand_sum_partition_subexpression) }
    let(:reduced_summand_factor_partition_subexpression) { double(:reduced_summand_factor_partition_subexpression) }

    it "returns the reductions of the summand expression" do
      expect(reduce).to include(
        reduced_expression: reduced_summand,
        sum_partition: [5, reduced_summand_sum_partition_subexpression],
        factor_partition: [2, reduced_summand_factor_partition_subexpression]
      )
    end
  end
end
