# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/exponentiate_expression_reduction_analyzer"

RSpec.describe SymDiffer::ExpressionReduction::ExponentiateExpressionReductionAnalyzer do
  let(:reduction_analyzer) { described_class.new(expression_factory, reduction_analysis_visitor) }

  let(:expression_factory) { sym_differ_expression_factory }
  let(:reduction_analysis_visitor) { double(:reduction_analysis_visitor) }

  describe "#reduce_expression" do
    subject(:reduce_expression) do
      described_class
        .new(expression_factory, reduction_analysis_visitor)
        .reduce_expression(expression)
    end

    before do
      allow(base)
        .to receive(:accept)
        .with(reduction_analysis_visitor)
        .and_return(constant_expression(2))

      allow(power)
        .to receive(:accept)
        .with(reduction_analysis_visitor)
        .and_return(constant_expression(4))
    end

    let(:expression) { exponentiate_expression(base, power) }

    let(:base) { double(:base) }
    let(:power) { double(:power) }

    it "returns the expected constant expression" do
      expect(reduce_expression).to be_same_as(
        exponentiate_expression(
          constant_expression(2),
          constant_expression(4)
        )
      )
    end
  end

  describe "#make_sum_partition" do
    subject(:make_sum_partition) do
      reduction_analyzer.make_sum_partition(expression)
    end

    before do
      allow(base)
        .to receive(:accept)
        .with(reduction_analysis_visitor)
        .and_return(constant_expression(2))

      allow(power)
        .to receive(:accept)
        .with(reduction_analysis_visitor)
        .and_return(constant_expression(4))
    end

    let(:expression) { exponentiate_expression(base, power) }

    let(:base) { double(:base) }
    let(:power) { double(:power) }

    let(:expected_reduced_expression) do
      exponentiate_expression(
        constant_expression(2), constant_expression(4)
      )
    end

    it { is_expected.to match(sum_partition(0, same_expression_as(expected_reduced_expression))) }

    define_method(:sum_partition) do |constant, subexpression|
      [constant, subexpression]
    end
  end

  describe "#make_factor_partition" do
    subject(:make_factor_partition) do
      reduction_analyzer.make_factor_partition(expression)
    end

    before do
      allow(base)
        .to receive(:accept)
        .with(reduction_analysis_visitor)
        .and_return(constant_expression(2))

      allow(power)
        .to receive(:accept)
        .with(reduction_analysis_visitor)
        .and_return(constant_expression(4))
    end

    let(:expression) { exponentiate_expression(base, power) }

    let(:base) { double(:base) }
    let(:power) { double(:power) }

    let(:expected_reduced_expression) do
      exponentiate_expression(
        constant_expression(2), constant_expression(4)
      )
    end

    it { is_expected.to match(factor_partition(1, same_expression_as(expected_reduced_expression))) }

    define_method(:factor_partition) do |constant, subexpression|
      [constant, subexpression]
    end
  end
end
