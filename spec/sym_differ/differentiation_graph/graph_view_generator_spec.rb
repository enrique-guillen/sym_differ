# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_graph/graph_view_generator"

RSpec.describe SymDiffer::DifferentiationGraph::GraphViewGenerator do
  describe "#generate" do
    subject(:generate) do
      described_class
        .new(variable, expression_stringifier)
        .generate(expression, derivative_expression, parameters)
    end

    before do
      allow(expression_stringifier).to receive(:stringify).with(expression).and_return("fun(x)")
      allow(expression_stringifier).to receive(:stringify).with(derivative_expression).and_return("defun(x)")
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:variable) { "x" }
    let(:expression_stringifier) { double(:expression_stringifier) }

    let(:expression) { double(:expression) }
    let(:derivative_expression) { double(:derivative_expression) }

    context "when expression path = x cubed, derivative expression path = 2 * x" do
      let(:parameters) do
        {
          expression_path: create_expression_path(expected_expression_path),
          derivative_expression_path: create_expression_path(expected_derivative_expression_path),
          max_ordinate_value: 1000.0,
          min_ordinate_value: -1000.0,
          ordinate_distance: 2000.0
        }
      end

      let(:expected_expression_path) do
        expression_path_steps.map { |s| create_evaluation_point(s, s**3) }
      end

      let(:expected_derivative_expression_path) do
        expression_path_steps.map { |s| create_evaluation_point(s, 2 * (s**2)) }
      end

      let(:scaled_path) do
        an_object_having_attributes(
          evaluation_points: [
            create_evaluation_point(-10.0, -1000.0),
            create_evaluation_point(0.0, 0.0),
            create_evaluation_point(10.0, 1000.0)
          ].map { |p| same_evaluation_point_as(p) }
        )
      end

      let(:scaled_derivative_path) do
        an_object_having_attributes(
          evaluation_points: [
            create_evaluation_point(-10.0, 200.0),
            create_evaluation_point(0.0, 0.0),
            create_evaluation_point(10.0, 200.0)
          ].map { |p| same_evaluation_point_as(p) }
        )
      end

      let(:expression_path_steps) do
        [-10.0, 0.0, 10.0]
      end

      it "has the expected curves" do
        expect(generate).to have_attributes(
          curves: [
            an_object_having_attributes(text: "Expression: fun(x)", path: scaled_path),
            an_object_having_attributes(text: "Derivative: defun(x)", path: scaled_derivative_path)
          ]
        )
      end

      it "has the expected asbcissa axis" do
        expect(generate).to have_attributes(
          abscissa_axis: an_object_having_attributes(
            name: "x", origin: -10.0, number_labels: [-10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0]
          )
        )
      end

      it "has the expected ordinate axis" do
        expect(generate).to have_attributes(
          ordinate_axis: an_object_having_attributes(
            name: "y", origin: 1000.0,
            number_labels: [-1000.0, -800.0, -600.0, -400.0, -200.0, 0.0, 200.0, 400.0, 600.0, 800.0, 1000.0]
          )
        )
      end
    end

    context "when expression path = 0, derivative expression path = 0" do
      let(:parameters) do
        {
          expression_path: create_expression_path(expected_expression_path),
          derivative_expression_path: create_expression_path(expected_derivative_expression_path),
          max_ordinate_value: 0,
          min_ordinate_value: 0,
          ordinate_distance: 0
        }
      end

      let(:expected_expression_path) do
        expression_path_steps.map { |s| create_evaluation_point(s, 0) }
      end

      let(:expected_derivative_expression_path) do
        expression_path_steps.map { |s| create_evaluation_point(s, 0) }
      end

      let(:scaled_path) do
        an_object_having_attributes(
          evaluation_points: [
            create_evaluation_point(-10.0, -0.0),
            create_evaluation_point(0.0, 0.0),
            create_evaluation_point(10.0, 0.0)
          ].map { |p| same_evaluation_point_as(p) }
        )
      end

      let(:scaled_derivative_path) do
        an_object_having_attributes(
          evaluation_points: [
            create_evaluation_point(-10.0, 0.0),
            create_evaluation_point(0.0, 0.0),
            create_evaluation_point(10.0, 0.0)
          ].map { |p| same_evaluation_point_as(p) }
        )
      end

      let(:expression_path_steps) do
        [-10.0, 0.0, 10.0]
      end

      it "has the expected curves" do
        expect(generate).to have_attributes(
          curves: [
            an_object_having_attributes(text: "Expression: fun(x)", path: scaled_path),
            an_object_having_attributes(text: "Derivative: defun(x)", path: scaled_derivative_path)
          ]
        )
      end

      it "has the expected abscissa axis" do
        expect(generate).to have_attributes(
          abscissa_axis: an_object_having_attributes(
            name: "x", origin: -10.0,
            number_labels: [-10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0]
          )
        )
      end

      it "has the expected ordinate axis" do
        expect(generate).to have_attributes(
          ordinate_axis: an_object_having_attributes(
            name: "y", origin: 0.0,
            number_labels: [0.0, 0.1, 0.2, 0.30000000000000004, 0.4, 0.5,
                            0.6000000000000001, 0.7000000000000001, 0.8, 0.9, 1.0]
          )
        )
      end
    end
  end
end
