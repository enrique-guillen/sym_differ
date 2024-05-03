# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/variable_expression_reducer"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReduction::VariableExpressionReducer do
  describe "#reduce" do
    subject(:reduce) { described_class.new.reduce(expression) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    let(:expression) { variable_expression("x") }

    it "returns the reductions of the variable expression" do
      expect(reduce).to include(
        reduced_expression: expression,
        sum_partition: [0, expression],
        factor_partition: [1, expression]
      )
    end
  end
end
