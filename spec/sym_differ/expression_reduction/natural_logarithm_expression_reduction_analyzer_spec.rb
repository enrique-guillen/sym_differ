# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/natural_logarithm_expression_reduction_analyzer"

RSpec.describe SymDiffer::ExpressionReduction::NaturalLogarithmExpressionReductionAnalyzer do
  let(:reduction_analyzer) { described_class.new(expression_factory, expression_reducer) }

  let(:expression_factory) { sym_differ_expression_factory }
  let(:expression_reducer) { double(:expression_reducer) }

  describe "#reduce_expression" do
    subject(:reduce_expression) do
      reduction_analyzer.reduce_expression(expression)
    end

    before do
      allow(expression_reducer)
        .to receive(:reduce)
        .with(power_expression)
        .and_return(reduced_power_expression)
    end

    let(:expression) { natural_logarithm_expression(power_expression) }
    let(:power_expression) { double(:power_expression) }

    context "when reduced_power_expression is an expression that cannot be reduced" do
      let(:reduced_power_expression) { expression_test_double(:reduced_power_expression) }

      it { is_expected.to be_same_as(natural_logarithm_expression(reduced_power_expression)) }
    end

    context "when the reduced power expression is the same as the euler_number_expression" do
      let(:reduced_power_expression) { euler_number_expression }

      it { is_expected.to be_same_as(constant_expression(1)) }
    end

    context "when the reduced power expression is the same as 1" do
      let(:reduced_power_expression) { constant_expression(1) }

      it { is_expected.to be_same_as(constant_expression(0)) }
    end

    context "when the reduced power expression is the same as x * y" do
      before do
        allow(expression_reducer)
          .to receive(:reduce)
          .with(
            same_expression_as(
              sum_expression(
                natural_logarithm_expression(multiplicand),
                natural_logarithm_expression(multiplier)
              )
            )
          )
          .and_return(reduced_sum_of_logarithms)
      end

      let(:reduced_power_expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:reduced_sum_of_logarithms) { double(:reduced_sum_of_logarithms) }

      let(:multiplicand) { expression_test_double(:multiplicand) }
      let(:multiplier) { expression_test_double(:multiplier) }

      it "returns ln(x) + ln(y)" do
        expect(reduce_expression).to eq(reduced_sum_of_logarithms)
      end
    end

    context "when the reduced power expression is the same as x ^ y" do
      before do
        allow(expression_reducer)
          .to receive(:reduce)
          .with(
            same_expression_as(
              multiplicate_expression(
                power,
                natural_logarithm_expression(base)
              )
            )
          )
          .and_return(reduced_multiplication_of_logarithms)
      end

      let(:reduced_power_expression) do
        exponentiate_expression(base, power)
      end

      let(:reduced_multiplication_of_logarithms) do
        double(:reduced_multiplication_of_logarithms)
      end

      let(:base) { expression_test_double(:base) }
      let(:power) { expression_test_double(:power) }

      it "returns y*ln(x))" do
        expect(reduce_expression).to eq(reduced_multiplication_of_logarithms)
      end
    end
  end

  describe "#make_factor_partition" do
    subject(:make_factor_partition) do
      reduction_analyzer.make_factor_partition(expression)
    end

    before do
      allow(expression_reducer)
        .to receive(:reduce)
        .with(power_expression)
        .and_return(reduced_power_expression)
    end

    let(:expression) { natural_logarithm_expression(power_expression) }
    let(:power_expression) { double(:power_expression) }

    context "when the reduced expression equals ln(x)" do
      let(:reduced_power_expression) { expression_test_double(:reduced_power_expression) }

      it "returns the factor partition 1, x" do
        expect(make_factor_partition).to match(
          factor_partition(
            1,
            same_expression_as(
              natural_logarithm_expression(reduced_power_expression)
            )
          )
        )
      end
    end

    context "when the reduced expression equals 1" do
      let(:reduced_power_expression) { euler_number_expression }

      it "returns the factor partition 1, nil" do
        expect(make_factor_partition).to match(factor_partition(1, nil))
      end
    end

    define_method(:factor_partition) do |constant, subexpression|
      [constant, subexpression]
    end
  end
end
