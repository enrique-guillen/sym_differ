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
      allow(reduction_analysis_visitor)
        .to receive(:reduce)
        .with(base)
        .and_return(reduced_base)

      allow(reduction_analysis_visitor)
        .to receive(:reduce)
        .with(power)
        .and_return(reduced_power)
    end

    let(:expression) { exponentiate_expression(base, power) }

    let(:base) { double(:base) }
    let(:power) { double(:power) }

    context "when reduced_base = x, reduced_power = 4" do
      let(:reduced_base) { variable_expression("x") }
      let(:reduced_power) { constant_expression(4) }

      it "returns the expected exponentiate expression" do
        expect(reduce_expression).to be_same_as(
          exponentiate_expression(
            variable_expression("x"),
            constant_expression(4)
          )
        )
      end
    end

    context "when reduced_base = 2, reduced_power = 0" do
      let(:reduced_base) { constant_expression(2) }
      let(:reduced_power) { constant_expression(0) }

      it "returns the expected constant expression 1" do
        expect(reduce_expression).to be_same_as(constant_expression(1))
      end
    end

    context "when reduced_base = 2, reduced_power = 1" do
      let(:reduced_base) { constant_expression(2) }
      let(:reduced_power) { constant_expression(1) }

      it "returns the expected constant expression 2" do
        expect(reduce_expression).to be_same_as(constant_expression(2))
      end
    end

    context "when reduced_base = 0, reduced_power = 2" do
      let(:reduced_base) { constant_expression(0) }
      let(:reduced_power) { constant_expression(2) }

      it "returns the expected constant expression 0" do
        expect(reduce_expression).to be_same_as(constant_expression(0))
      end
    end

    context "when reduced_base = 2, reduced_power = 2" do
      let(:reduced_base) { constant_expression(2) }
      let(:reduced_power) { constant_expression(2) }

      it "returns the expected constant expression 4" do
        expect(reduce_expression).to be_same_as(constant_expression(4))
      end
    end
  end

  describe "#make_sum_partition" do
    subject(:make_sum_partition) do
      reduction_analyzer.make_sum_partition(expression)
    end

    before do
      allow(reduction_analysis_visitor)
        .to receive(:reduce)
        .with(base)
        .and_return(constant_expression(2))

      allow(reduction_analysis_visitor)
        .to receive(:reduce)
        .with(power)
        .and_return(constant_expression(4))
    end

    let(:expression) { exponentiate_expression(base, power) }

    let(:base) { double(:base) }
    let(:power) { double(:power) }

    let(:expected_reduced_expression) do
      constant_expression(16)
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
      allow(reduction_analysis_visitor)
        .to receive(:reduce)
        .with(base)
        .and_return(constant_expression(2))

      allow(reduction_analysis_visitor)
        .to receive(:reduce)
        .with(power)
        .and_return(constant_expression(4))
    end

    let(:expression) { exponentiate_expression(base, power) }

    let(:base) { double(:base) }
    let(:power) { double(:power) }

    let(:expected_reduced_expression) do
      constant_expression(16)
    end

    it { is_expected.to match(factor_partition(1, same_expression_as(expected_reduced_expression))) }

    define_method(:factor_partition) do |constant, subexpression|
      [constant, subexpression]
    end
  end
end
