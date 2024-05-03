# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/constant_expression_reducer"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReduction::ConstantExpressionReducer do
  describe "#reduce" do
    subject(:reduce) { described_class.new.reduce(expression) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    context "when the expression is 1" do
      let(:expression) { constant_expression(1) }

      it "returns the reductions of the constant expression" do
        expect(reduce).to include(
          reduced_expression: expression,
          sum_partition: [1, nil],
          factor_partition: [1, nil]
        )
      end
    end
  end
end
