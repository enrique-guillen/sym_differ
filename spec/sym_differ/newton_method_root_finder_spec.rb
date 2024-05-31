# frozen_string_literal: true

require "spec_helper"
require "sym_differ/newton_method_root_finder"

RSpec.describe SymDiffer::NewtonMethodRootFinder do
  describe "#find" do
    subject(:find) do
      described_class
        .new(derivative_approximation_dx,
             expression_evaluator,
             fixed_point_finder_creator)
        .find(expression, variable, first_guess)
    end

    before do
      allow(expression_evaluator)
        .to receive(:evaluate)
        .with(expression, a_hash_including("x" => anything)) do |_expression, variable_values|
          variable_values.fetch("x")
        end

      expected_evaluator_matcher =
        an_object_satisfying do |evaluator|
          evaluator.evaluate(expression, "x" => 1.0) + 6.07747097092215e-09 == 0.0
        end

      allow(fixed_point_finder_creator)
        .to receive(:create)
        .with(expected_evaluator_matcher)
        .and_return(fixed_point_finder)

      allow(fixed_point_finder)
        .to receive(:approximate)
        .with(expression, variable, first_guess)
        .and_return(fixed_point_finder_result)
    end

    let(:derivative_approximation_dx) { 0.00000001 }
    let(:expression_evaluator) { double(:expression_evaluator) }

    let(:fixed_point_finder_creator) do
      double(:fixed_point_finder_creator)
    end

    let(:fixed_point_finder) do
      double(:fixed_point_finder)
    end

    let(:expression) { double(:expression) }
    let(:variable) { "x" }
    let(:first_guess) { 1.0 }

    let(:fixed_point_finder_result) do
      double(:fixed_point_finder_result)
    end

    it "calls the fixed-point finder with the newton-transform of the expression and more" do
      expect(find).to eq(fixed_point_finder_result)
    end
  end
end
