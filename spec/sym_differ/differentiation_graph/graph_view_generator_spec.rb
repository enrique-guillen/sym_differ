# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_graph/graph_view_generator"

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
        evaluation_point(-10.0, -5.0), evaluation_point(-8.0, -2.56), evaluation_point(-6.0, -1.08),
        evaluation_point(-4.0, -0.32), evaluation_point(-2.0, -0.04), evaluation_point(0.0, 0.0),
        evaluation_point(2.0, 0.04), evaluation_point(4.0, 0.32), evaluation_point(6.0, 1.08),
        evaluation_point(8.0, 2.56), evaluation_point(10.0, 5.0)
      ]
    end

    let(:scaled_expected_derivative_expression_path) do
      [
        evaluation_point(-10.0, 1.0), evaluation_point(-8.0, 0.64), evaluation_point(-6.0, 0.36),
        evaluation_point(-4.0, 0.16), evaluation_point(-2.0, 0.04), evaluation_point(0.0, 0.0),
        evaluation_point(2.0, 0.04), evaluation_point(4.0, 0.16), evaluation_point(6.0, 0.36),
        evaluation_point(8.0, 0.64), evaluation_point(10.0, 1.0)
      ]
    end

    let(:expression_path_steps) do
      [-10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0]
    end

    it "has the expected attributes" do
      expect(generate).to have_attributes(
        show_total_area_aid: false,
        abscissa_name: "x", ordinate_name: "y",
        expression_text: "fun(x)", derivative_expression_text: "defun(x)",
        expression_path: scaled_expected_expression_path,
        derivative_expression_path: scaled_expected_derivative_expression_path,
        abscissa_number_labels: [-10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0],
        origin_abscissa: 50, abscissa_offset: 0.0,
        ordinate_number_labels: [-1000.0, -800.0, -600.0, -400.0, -200.0, 0.0, 200.0, 400.0, 600.0, 800.0, 1000.0],
        origin_ordinate: 5.0, ordinate_offset: 0.0
      )
    end
  end

  describe "#scale_to_10_height_presentation" do
    subject(:scale_to_10_height_presentation) do
      described_class
        .new(variable, expression_stringifier, expression_path_generator)
        .scale_to_10_height_presentation(expression_path, distance)
    end

    let(:variable) { "x" }
    let(:expression_stringifier) { double(:expression_stringifier) }
    let(:expression_path_generator) { double(:expression_path_generator) }

    let(:expression_path) do
      [evaluation_point(-10.0, -60.0),
       evaluation_point(0.0, 30.0),
       evaluation_point(10.0, 40.0)]
    end

    let(:distance) { 100 }

    it "returns the evaluation points scaled down by the distance/100 factor" do
      expect(scale_to_10_height_presentation).to eq(
        [evaluation_point(-10.0, -6.0),
         evaluation_point(0.0, 3.0),
         evaluation_point(10.0, 4.0)]
      )
    end
  end

  define_method(:evaluation_point) do |abscissa, ordinate|
    [abscissa, ordinate]
  end
end
