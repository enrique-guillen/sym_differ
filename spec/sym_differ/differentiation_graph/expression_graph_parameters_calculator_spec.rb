# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_graph/expression_graph_parameters_calculator"

RSpec.describe SymDiffer::DifferentiationGraph::ExpressionGraphParametersCalculator do
  describe "#generate" do
    subject(:generate) do
      described_class
        .new(variable, expression_path_generator, step_range)
        .calculate(expression, derivative_expression)
    end

    before do
      allow(expression_path_generator)
        .to receive(:generate)
        .with(expression, variable, an_object_having_attributes(first_element: -10.0, last_element: 10.0))
        .and_return(create_expression_path(expected_expression_path))

      allow(expression_path_generator)
        .to receive(:generate)
        .with(derivative_expression, variable, an_object_having_attributes(first_element: -10.0, last_element: 10.0))
        .and_return(create_expression_path(expected_derivative_expression_path))
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:variable) { "x" }
    let(:expression_path_generator) { double(:expression_path_generator) }
    let(:step_range) { create_step_range(-10..10.0) }

    let(:expression) { double(:expression) }
    let(:derivative_expression) { double(:derivative_expression) }

    let(:expected_expression_path) do
      expression_path_steps.map { |s| create_evaluation_point(s, s**3) }
    end

    let(:expected_derivative_expression_path) do
      expression_path_steps.map { |s| create_evaluation_point(s, 2 * (s**2)) }
    end

    let(:path) do
      [
        create_evaluation_point(-10.0, -1000.0),
        create_evaluation_point(-8.0, -512.0),
        create_evaluation_point(-6.0, -216.0),
        create_evaluation_point(-4.0, -64.0),
        create_evaluation_point(-2.0, -8.0),
        create_evaluation_point(0.0, 0.0),
        create_evaluation_point(2.0, 8.0),
        create_evaluation_point(4.0, 64.0),
        create_evaluation_point(6.0, 216.0),
        create_evaluation_point(8.0, 512.0),
        create_evaluation_point(10.0, 1000.0)
      ].map { |p| same_evaluation_point_as(p) }
    end

    let(:derivative_path) do
      [
        create_evaluation_point(-10.0, 200.0),
        create_evaluation_point(-8.0, 128.0),
        create_evaluation_point(-6.0, 72.0),
        create_evaluation_point(-4.0, 32.0),
        create_evaluation_point(-2.0, 8.0),
        create_evaluation_point(0.0, 0.0),
        create_evaluation_point(2.0, 8.0),
        create_evaluation_point(4.0, 32.0),
        create_evaluation_point(6.0, 72.0),
        create_evaluation_point(8.0, 128.0),
        create_evaluation_point(10.0, 200.0)
      ].map { |p| same_evaluation_point_as(p) }
    end

    let(:expression_path_steps) do
      [-10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0]
    end

    it "has the expected attributes" do
      expect(generate).to include(
        expression_path:
          an_object_having_attributes(evaluation_points: a_collection_containing_exactly(*path)),
        derivative_expression_path:
          an_object_having_attributes(evaluation_points: a_collection_containing_exactly(*derivative_path)),
        min_abscissa_value: -10.0,
        max_abscissa_value: 10.0,
        abscissa_distance: 20.0,
        max_ordinate_value: 1000.0,
        min_ordinate_value: -1000.0,
        ordinate_distance: 2000.0
      )
    end
  end
end
