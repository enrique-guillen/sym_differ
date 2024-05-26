# frozen_string_literal: true

require "spec_helper"
require "sym_differ/fixed_point_approximator"

RSpec.describe SymDiffer::FixedPointApproximator do
  describe "#approximate" do
    subject(:approximate) do
      described_class
        .new(tolerance, expression_evaluator)
        .approximate(expression, variable, first_guess)
    end

    let(:expression_evaluator) { double(:expression_evaluator) }

    let(:expression_factory) { sym_differ_expression_factory }
    let(:variable) { "x" }

    context "when the expression is 1.0, tolerance = 100" do
      before do
        allow(expression_evaluator)
          .to receive(:evaluate)
          .with(expression, a_hash_including("x" => anything))
          .and_return(1.0)
      end

      let(:expression) { double(:expression) }

      let(:tolerance) { 100.0 }

      context "when first_guess = 1" do
        let(:first_guess) { 1.0 }

        it { is_expected.to eq(1.0) }
      end

      context "when first_guess = 9" do
        let(:first_guess) { 9.0 }

        it { is_expected.to eq(1.0) }
      end
    end

    context "when the expression is x / 2, tolerance = 10" do
      before do
        allow(expression_evaluator)
          .to receive(:evaluate)
          .with(expression, a_hash_including("x" => anything)) do |_expression, variable_values|
            variable_values.fetch(variable) / 2.0
          end
      end

      let(:expression) { double(:expression) }
      let(:tolerance) { 10 }

      context "when first_guess = 1.0" do
        let(:first_guess) { 1.0 }

        it { is_expected.to eq(0.5) }
      end

      context "when first_guess = 30.0" do
        let(:first_guess) { 30.0 }

        it { is_expected.to eq(7.5) }
      end
    end

    context "when the expression is x / -2, tolerance = 10" do
      before do
        allow(expression_evaluator)
          .to receive(:evaluate)
          .with(expression, a_hash_including("x" => anything)) do |_expression, variable_values|
            variable_values.fetch(variable) / -2.0
          end
      end

      let(:expression) { double(:expression) }
      let(:tolerance) { 5 }

      context "when first_guess = -30.0" do
        let(:first_guess) { -30.0 }

        it { is_expected.to eq(0.9375) }
      end
    end
  end
end
