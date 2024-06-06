# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/constant_expression_reduction_analyzer"

RSpec.describe SymDiffer::ExpressionReduction::ConstantExpressionReductionAnalyzer do
  let(:expression_factory) { sym_differ_expression_factory }

  describe "#reduce_expression" do
    subject(:reduce_expression) do
      described_class.new.reduce_expression(expression)
    end

    let(:expression) { constant_expression(1) }

    it { is_expected.to eq(expression) }
  end

  describe "#make_sum_partition" do
    subject(:make_sum_partition) do
      described_class.new.make_sum_partition(expression)
    end

    let(:expression) { constant_expression(1) }

    it { is_expected.to eq(sum_partition(1, nil)) }

    define_method(:sum_partition) do |constant, subexpression|
      [constant, subexpression]
    end
  end

  describe "#make_factor_partition" do
    subject(:make_factor_partition) do
      described_class.new.make_factor_partition(expression)
    end

    let(:expression) { constant_expression(1) }

    it { is_expected.to eq(factor_partition(1, nil)) }

    define_method(:factor_partition) do |constant, subexpression|
      [constant, subexpression]
    end
  end
end
