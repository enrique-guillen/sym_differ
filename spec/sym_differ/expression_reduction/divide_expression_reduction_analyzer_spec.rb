# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/divide_expression_reduction_analyzer"

RSpec.describe SymDiffer::ExpressionReduction::DivideExpressionReductionAnalyzer do
  let(:reduction_analyzer) { described_class.new(expression_factory, reduction_analysis_visitor) }

  let(:expression_factory) { sym_differ_expression_factory }
  let(:reduction_analysis_visitor) { double(:reduction_analysis_visitor) }

  describe "#reduce_expression" do
    subject(:reduce_expression) do
      reduction_analyzer.reduce_expression(expression)
    end

    before do
      allow(numerator)
        .to receive(:accept)
        .with(reduction_analysis_visitor)
        .and_return(reduced_numerator)

      allow(denominator)
        .to receive(:accept)
        .with(reduction_analysis_visitor)
        .and_return(reduced_denominator)
    end

    let(:expression) do
      divide_expression(numerator, denominator)
    end

    let(:numerator) { double(:numerator) }
    let(:denominator) { double(:denominator) }

    context "when reduced_numerator = 2, reduced_denominator = 4" do
      let(:reduced_numerator) { constant_expression(2) }
      let(:reduced_denominator) { constant_expression(4) }

      it "returns the reductions of the division expression" do
        expect(reduce_expression).to be_same_as(
          divide_expression(
            constant_expression(2),
            constant_expression(4)
          )
        )
      end
    end

    context "when reduced_numerator = 0, reduced_denominator = 4" do
      let(:reduced_numerator) { constant_expression(0) }
      let(:reduced_denominator) { constant_expression(4) }

      it "returns the reductions of the division expression" do
        expect(reduce_expression).to be_same_as(constant_expression(0))
      end
    end

    context "when reduced_numerator = 0, reduced_denominator = 0" do
      let(:reduced_numerator) { constant_expression(0) }
      let(:reduced_denominator) { constant_expression(0) }

      it "returns the reductions of the division expression" do
        expect(reduce_expression).to be_same_as(
          divide_expression(constant_expression(0), constant_expression(0))
        )
      end
    end

    context "when reduced_numerator = x, reduced_denominator = 1" do
      let(:reduced_numerator) { variable_expression("x") }
      let(:reduced_denominator) { constant_expression(1) }

      it "returns the reductions of the division expression" do
        expect(reduce_expression).to be_same_as(variable_expression("x"))
      end
    end

    context "when reduced_numerator = x, reduced_denominator = x" do
      let(:reduced_numerator) { variable_expression("x") }
      let(:reduced_denominator) { variable_expression("x") }

      it "returns the reductions of the division expression" do
        expect(reduce_expression).to be_same_as(constant_expression(1))
      end
    end
  end

  describe "#make_sum_partition" do
    subject(:make_sum_partition) do
      reduction_analyzer.make_sum_partition(expression)
    end

    before do
      allow(numerator)
        .to receive(:accept)
        .with(reduction_analysis_visitor)
        .and_return(reduced_numerator)

      allow(denominator)
        .to receive(:accept)
        .with(reduction_analysis_visitor)
        .and_return(reduced_denominator)
    end

    let(:expression) do
      divide_expression(numerator, denominator)
    end

    let(:numerator) { double(:numerator) }
    let(:denominator) { double(:denominator) }

    context "when the reduced expression is a division" do
      let(:reduced_numerator) { constant_expression(2) }
      let(:reduced_denominator) { constant_expression(4) }

      let(:expected_reduced_expression) do
        divide_expression(
          constant_expression(2), constant_expression(4)
        )
      end

      it { is_expected.to match(sum_partition(0, same_expression_as(expected_reduced_expression))) }
    end

    context "when the reduced expression is a constant" do
      let(:reduced_numerator) { constant_expression(4) }
      let(:reduced_denominator) { constant_expression(1) }

      it { is_expected.to match(sum_partition(4, nil)) }
    end

    define_method(:sum_partition) do |constant, subexpression|
      [constant, subexpression]
    end
  end

  describe "#make_factor_partition" do
    subject(:make_factor_partition) do
      reduction_analyzer.make_factor_partition(expression)
    end

    before do
      allow(numerator)
        .to receive(:accept)
        .with(reduction_analysis_visitor)
        .and_return(reduced_numerator)

      allow(denominator)
        .to receive(:accept)
        .with(reduction_analysis_visitor)
        .and_return(reduced_denominator)
    end

    let(:expression) do
      divide_expression(numerator, denominator)
    end

    let(:numerator) { double(:numerator) }
    let(:denominator) { double(:denominator) }

    context "when the reduced expression is a division" do
      let(:reduced_numerator) { constant_expression(2) }
      let(:reduced_denominator) { constant_expression(4) }

      let(:expected_reduced_expression) do
        divide_expression(
          constant_expression(2), constant_expression(4)
        )
      end

      it { is_expected.to match(factor_partition(1, same_expression_as(expected_reduced_expression))) }
    end

    context "when the reduced expression is a constant" do
      let(:reduced_numerator) { constant_expression(4) }
      let(:reduced_denominator) { constant_expression(1) }

      it { is_expected.to match(factor_partition(4, nil)) }
    end

    define_method(:factor_partition) do |constant, subexpression|
      [constant, subexpression]
    end
  end
end
