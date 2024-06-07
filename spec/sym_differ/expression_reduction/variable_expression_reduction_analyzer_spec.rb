# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/variable_expression_reduction_analyzer"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReduction::VariableExpressionReductionAnalyzer do
  let(:reduction_analyzer) { described_class.new }
  let(:expression_factory) { sym_differ_expression_factory }

  describe "#reduce_expression" do
    subject(:reduce_expression) { reduction_analyzer.reduce_expression(expression) }

    let(:expression) { variable_expression("x") }

    it "returns the reductions of the variable expression" do
      expect(reduce_expression).to be_same_as(variable_expression("x"))
    end
  end

  describe "#make_sum_partition" do
    subject(:make_sum_partition) { reduction_analyzer.make_sum_partition(expression) }

    let(:expression) { variable_expression("x") }

    it "returns the reductions of the variable expression" do
      expect(make_sum_partition).to match(
        [0, same_expression_as(variable_expression("x"))]
      )
    end
  end

  describe "#make_factor_partition" do
    subject(:make_factor_partition) { reduction_analyzer.make_factor_partition(expression) }

    let(:expression) { variable_expression("x") }

    it "returns the reductions of the variable expression" do
      expect(make_factor_partition).to match(
        [1, same_expression_as(variable_expression("x"))]
      )
    end
  end
end
