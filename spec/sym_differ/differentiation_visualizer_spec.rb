# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_visualizer"

require "sym_differ/error"

RSpec.describe SymDiffer::DifferentiationVisualizer do
  describe "#visualize" do
    subject(:visualize) do
      described_class
        .new(expression_text_parser,
             deriver,
             expression_reducer,
             expression_stringifier,
             expression_path_generator,
             view_renderer,
             step_range)
        .visualize(expression_text, variable)
    end

    before do
      allow(expression_text_parser).to receive(:parse).with("x + x").with(expression_text).and_return(expression)
      allow(deriver).to receive(:derive).with(expression).and_return(derivative_expression)

      allow(expression_stringifier).to receive(:stringify).with(expression).and_return("x + x")
      allow(expression_stringifier).to receive(:stringify).with(reduced_derivative_expression).and_return("2")

      allow(expression_reducer)
        .to receive(:reduce)
        .with(derivative_expression)
        .and_return(reduced_derivative_expression)

      allow(expression_path_generator)
        .to receive(:generate)
        .with(expression, "x", step_range)
        .and_return(create_expression_path([evaluation_point(-10, -20), evaluation_point(10, 20)]))

      allow(expression_path_generator)
        .to receive(:generate)
        .with(reduced_derivative_expression, "x", step_range)
        .and_return(create_expression_path([evaluation_point(-10, 2), evaluation_point(10, 2)]))

      allow(view_renderer).to receive(:render).and_return(rendered_view)
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:expression_text_parser) { double(:expression_text_parser) }
    let(:deriver) { double(:deriver) }
    let(:expression_reducer) { double(:expression_reducer) }
    let(:expression_stringifier) { double(:expression_stringifier) }
    let(:expression_path_generator) { double(:expression_path_generator) }
    let(:view_renderer) { double(:view_renderer) }
    let(:step_range) { double(:step_range) }

    let(:expression_text) { "x + x" }
    let(:expression) { double(:expression) }
    let(:derivative_expression) { double(:derivative_expression) }
    let(:reduced_derivative_expression) { double(:reduced_derivative_expression) }
    let(:rendered_view) { double(:rendered_view) }

    context "when the variable is x" do
      before { allow(expression_text_parser).to receive(:validate_variable).with("x").and_return(true) }

      let(:variable) { "x" }

      let(:expected_expression_path) do
        an_object_having_attributes(
          evaluation_points: [same_evaluation_point_as(evaluation_point(-10.0, -20.0)),
                              same_evaluation_point_as(evaluation_point(10.0, 20.0))]
        )
      end

      let(:expected_derivative_expression_graph) do
        an_object_having_attributes(
          evaluation_points: [same_evaluation_point_as(evaluation_point(-10.0, 2.0)),
                              same_evaluation_point_as(evaluation_point(10.0, 2.0))]
        )
      end

      it { is_expected.to eq(rendered_view) }

      it "requests to render the expected abscissa axis" do
        visualize

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            abscissa_axis: an_object_having_attributes(
              name: "x",
              number_labels: [-10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0],
              origin: -10.0
            )
          )
        )
      end

      it "requests to render the expected ordinate axis" do
        visualize

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            ordinate_axis: an_object_having_attributes(
              name: "y",
              number_labels: [-20.0, -16.0, -12.0, -8.0, -4.0, 0.0, 4.0, 8.0, 12.0, 16.0, 20.0],
              origin: 20.0
            )
          )
        )
      end

      it "requests to render the expected expression graph" do
        visualize

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            curves: a_collection_including(
              an_object_having_attributes(text: "Expression: x + x", path: expected_expression_path)
            )
          )
        )
      end

      it "requests to render the expected derivative expression graph" do
        visualize

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            curves: a_collection_including(
              an_object_having_attributes(text: "Derivative: 2", path: expected_derivative_expression_graph)
            )
          )
        )
      end
    end

    context "when the variable is 1" do
      before do
        allow(expression_text_parser)
          .to receive(:validate_variable)
          .with("1")
          .and_raise(SymDiffer::Error, "Error")
      end

      let(:variable) { "1" }

      it "raises the error from the validate-variable call" do
        expect { visualize }.to raise_error(SymDiffer::Error, "Error")
      end
    end

    define_method(:evaluation_point) do |abscissa, ordinate|
      create_evaluation_point(abscissa, ordinate)
    end
  end
end
