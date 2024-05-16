# frozen_string_literal: true

require "spec_helper"
require "sym_differ/runge_kutta_four_solution_approximator"

require "sym_differ/differentiation_graph/step_range"

RSpec.describe SymDiffer::RungeKuttaFourSolutionApproximator do
  describe "#approximate_solution" do
    subject(:approximate_solution) do
      described_class
        .new(expression_evaluator, step_size)
        .approximate_solution(expression, "y", "x", initial_value_coordinates, step_range)
    end

    let(:expression_evaluator) { double(:expression_evaluator) }
    let(:expression) { double(:expression) }

    context "when the expression is 1, initial coordinates 0, step size 0.250" do
      before do
        allow(expression_evaluator)
          .to receive(:evaluate)
          .with(expression, { "x" => a_value_between(0.25, 1.25), "y" => a_value_between(0.0, 1.0) })
          .and_return(1.0)
      end

      let(:initial_value_coordinates) { [0.0, 0.0] }
      let(:step_size) { 0.250 }

      context "when step range = 0.25..0.25" do
        let(:step_range) { SymDiffer::DifferentiationGraph::StepRange.new(0.25..0.25) }

        it "returns the expected approximation over the given step range" do
          expect(approximate_solution).to eq(
            [[0.0, 0.0], [0.25, 0.24999999999999997]]
          )
        end
      end

      context "when step range = 0.25..1" do
        let(:step_range) { SymDiffer::DifferentiationGraph::StepRange.new(0.25..1) }

        it "returns the expected approximation over the given step range" do
          expect(approximate_solution).to eq(
            [
              [0.0, 0.0],
              [0.25, 0.24999999999999997],
              [0.5, 0.49999999999999994],
              [0.75, 0.75],
              [1.0, 1.0]
            ]
          )
        end
      end
    end

    context "when the expression is 2 * x + 1, initial coordinates (0, 1), step range = 0.125..1, step size 0.125" do
      before do
        allow(expression_evaluator)
          .to receive(:evaluate)
          .with(expression,
                { "x" => a_value_between(0.125, 1.25), "y" => a_value_between(0.0, 1.99) },
                &method(:evaluate_expression_as_2x_plus_1))
      end

      let(:initial_value_coordinates) { [0.0, 0.0] }
      let(:step_range) { SymDiffer::DifferentiationGraph::StepRange.new(0.125..1) }
      let(:step_size) { 0.125 }

      it "returns the expected approximation over the given step range" do
        expect(approximate_solution).to eq(
          [
            evaluation_point(0.0, 0.0), evaluation_point(0.125, 0.171875),
            evaluation_point(0.25, 0.37499999999999994), evaluation_point(0.375, 0.6093749999999999),
            evaluation_point(0.5, 0.8749999999999998), evaluation_point(0.625, 1.1718749999999996),
            evaluation_point(0.75, 1.4999999999999996), evaluation_point(0.875, 1.8593749999999998),
            evaluation_point(1.0, 2.25)
          ]
        )
      end
    end

    context "when the expression is y, initial coordinates (0, 1), step range = 0.125..1, step size 0.125" do
      before do
        allow(expression_evaluator)
          .to receive(:evaluate)
          .with(expression,
                { "x" => a_value_between(0.125, 1.25), "y" => a_value_between(1.0, 2.7) },
                &method(:evaluate_expression_as_y_identity))
      end

      let(:initial_value_coordinates) { [0.0, 1.0] }
      let(:step_range) { SymDiffer::DifferentiationGraph::StepRange.new(0.125..1) }
      let(:step_size) { 0.125 }

      it "returns the expected approximation over the given step range" do
        expect(approximate_solution).to eq(
          [
            evaluation_point(0.0, 1.0), evaluation_point(0.125, 1.1271974540051117),
            evaluation_point(0.25, 1.2705741003156061), evaluation_point(0.375, 1.4321878910005867),
            evaluation_point(0.5, 1.6143585443928121), evaluation_point(0.625, 1.8197008410909763),
            evaluation_point(0.75, 2.0511621551287096), evaluation_point(0.875, 2.3120647590127197),
            evaluation_point(1.0, 2.6061535098540802)
          ]
        )
      end
    end

    define_method(:evaluation_point) do |abscissa, ordinate|
      [abscissa, ordinate]
    end

    define_method(:evaluate_expression_as_2x_plus_1) do |_expression, variables|
      (2 * variables.fetch("x")) + 1
    end

    define_method(:evaluate_expression_as_y_identity) do |_expression, variables|
      variables.fetch("y")
    end
  end
end
