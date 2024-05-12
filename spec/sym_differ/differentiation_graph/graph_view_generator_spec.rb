# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_graph/graph_view_generator"

require "sym_differ/differentiation_graph/evaluation_point"

RSpec.describe SymDiffer::DifferentiationGraph::GraphViewGenerator do
  describe "#generate" do
    subject(:generate) do
      described_class
        .new(variable, expression_stringifier, expression_path_generator)
        .generate(expression, derivative_expression)
    end

    before do
      allow(expression_stringifier).to receive(:stringify).with(expression).and_return("fun(x)")
      allow(expression_stringifier).to receive(:stringify).with(derivative_expression).and_return("defun(x)")

      allow(expression_path_generator)
        .to receive(:generate)
        .with(expression, variable, an_object_having_attributes(first_element: -10.0, last_element: 10.0))
        .and_return(expected_expression_path)

      allow(expression_path_generator)
        .to receive(:generate)
        .with(derivative_expression, variable, an_object_having_attributes(first_element: -10.0, last_element: 10.0))
        .and_return(expected_derivative_expression_path)
    end

    let(:variable) { "x" }
    let(:expression_stringifier) { double(:expression_stringifier) }
    let(:expression_path_generator) { double(:expression_path_generator) }

    let(:expression) { double(:expression) }
    let(:derivative_expression) { double(:derivative_expression) }

    let(:expected_expression_path) do
      expression_path_steps.map { |s| evaluation_point(s, s**3) }
    end

    let(:expected_derivative_expression_path) do
      expression_path_steps.map { |s| evaluation_point(s, 2 * (s**2)) }
    end

    let(:scaled_expected_expression_path) do
      [
        evaluation_point(-50.0, -50.0), evaluation_point(-40.0, -25.6), evaluation_point(-30.0, -10.8),
        evaluation_point(-20.0, -3.2), evaluation_point(-10.0, -0.4), evaluation_point(0.0, 0.0),
        evaluation_point(10.0, 0.4), evaluation_point(20.0, 3.2), evaluation_point(30.0, 10.8),
        evaluation_point(40.0, 25.6), evaluation_point(50.0, 50.0)
      ].map { |p| same_evaluation_point_as(p) }
    end

    let(:scaled_expected_derivative_expression_path) do
      [
        evaluation_point(-50.0, 10.0), evaluation_point(-40.0, 6.4), evaluation_point(-30.0, 3.6),
        evaluation_point(-20.0, 1.6), evaluation_point(-10.0, 0.4), evaluation_point(0.0, 0.0),
        evaluation_point(10.0, 0.4), evaluation_point(20.0, 1.6), evaluation_point(30.0, 3.6),
        evaluation_point(40.0, 6.4), evaluation_point(50.0, 10.0)
      ].map { |p| same_evaluation_point_as(p) }
    end

    let(:expression_path_steps) do
      [-10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0]
    end

    it "has the expected attributes" do
      expect(generate).to have_attributes(
        show_total_area_aid: false,
        abscissa_name: "x", ordinate_name: "y",
        expression_text: "fun(x)", derivative_expression_text: "defun(x)",
        expression_path: a_collection_containing_exactly(*scaled_expected_expression_path),
        derivative_expression_path: a_collection_containing_exactly(*scaled_expected_derivative_expression_path),
        abscissa_number_labels: [-10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0],
        origin_abscissa: 50, abscissa_offset: 0.0,
        ordinate_number_labels: [-1000.0, -800.0, -600.0, -400.0, -200.0, 0.0, 200.0, 400.0, 600.0, 800.0, 1000.0],
        origin_ordinate: 50.0, ordinate_offset: 0.0
      )
    end
  end

  define_method(:evaluation_point) do |abscissa, ordinate|
    SymDiffer::DifferentiationGraph::EvaluationPoint.new(abscissa, ordinate)
  end
end
