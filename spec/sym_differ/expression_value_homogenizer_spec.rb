# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_value_homogenizer"

RSpec.describe SymDiffer::ExpressionValueHomogenizer do
  describe "#homogenize" do
    subject(:homogenize) do
      described_class.new.homogenize(&method_to_yield)
    end

    context "when the variable_values are empty, evaluation returns 10" do
      let(:method_to_yield) do
        proc { 10 }
      end

      let(:variable_values) { {} }

      it { is_expected.to eq(10) }
    end

    context "when the evaluation raises FloatDomainError" do
      let(:method_to_yield) do
        proc { raise FloatDomainError }
      end

      let(:variable_values) { {} }

      it { is_expected.to eq(:undefined) }
    end

    context "when the evaluator raises ZeroDivisionError" do
      let(:method_to_yield) do
        proc { raise ZeroDivisionError }
      end

      let(:variable_values) { {} }

      it { is_expected.to eq(:undefined) }
    end

    context "when the variable_values are empty, evaluation returns Float::NAN" do
      let(:method_to_yield) do
        proc { Float::NAN }
      end

      let(:variable_values) { {} }

      it { is_expected.to eq(:undefined) }
    end

    context "when the variable_values are empty, evaluation returns Float::INFINITY (clarification)" do
      let(:method_to_yield) do
        proc { Float::INFINITY }
      end

      let(:variable_values) { {} }

      it { is_expected.to eq(:undefined) }
    end
  end
end
