# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_and_derivative_expression_visualizer"

require "sym_differ/error"

RSpec.describe SymDiffer::ExpressionAndDerivativeExpressionVisualizer do
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
        .and_return([evaluation_point(-10, -20), evaluation_point(10, 20)])

      allow(expression_path_generator)
        .to receive(:generate)
        .with(reduced_derivative_expression, "x", step_range)
        .and_return([evaluation_point(-10, 2), evaluation_point(10, 2)])

      allow(view_renderer).to receive(:render).and_return(rendered_view)
    end

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

      it { is_expected.to eq(rendered_view) }

      it "requests to render the expected view" do
        visualize

        expect(view_renderer).to have_received(:render).with(an_object_having_attributes(show_total_area_aid: false))
      end

      it "requests to render the expected abscissa axis" do
        visualize

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            show_total_area_aid: false,
            abscissa_axis: an_object_having_attributes(
              name: "x",
              number_labels: [-10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0],
              origin: 50,
              offset: 0.0
            )
          )
        )
      end

      it "requests to render the expected ordinate axis" do
        visualize

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            show_total_area_aid: false,
            ordinate_axis: an_object_having_attributes(
              name: "y",
              number_labels: [-20.0, -16.0, -12.0, -8.0, -4.0, 0.0, 4.0, 8.0, 12.0, 16.0, 20.0],
              origin: 50,
              offset: 0.0
            )
          )
        )
      end

      it "requests to render the expected expression graph" do
        visualize

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            expression_graph: an_object_having_attributes(
              text: "x + x",
              path: [same_evaluation_point_as(evaluation_point(-50.0, -50.0)),
                     same_evaluation_point_as(evaluation_point(50.0, 50.0))]
            )
          )
        )
      end

      it "requests to render the expected derivative expression graph" do
        visualize

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            derivative_expression_graph: an_object_having_attributes(
              text: "2",
              path: [same_evaluation_point_as(evaluation_point(-50.0, 5.0)),
                     same_evaluation_point_as(evaluation_point(50.0, 5.0))]
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
      SymDiffer::DifferentiationGraph::EvaluationPoint.new(abscissa, ordinate)
    end
  end
end
