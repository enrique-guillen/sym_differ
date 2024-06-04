# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differential_equation_approximation_illustrator"

RSpec.describe SymDiffer::DifferentialEquationApproximationIllustrator do
  describe "#illustrate_approximation" do
    subject(:illustrate_approximation) do
      described_class
        .new(expression_text_parser, expression_stringifier, solution_approximator, view_renderer)
        .illustrate_approximation(
          expression_text, undetermined_function_name, variable_name, initial_value_coordinates, step_range
        )
    end

    before do
      allow(expression_text_parser).to receive(:parse).with("y").and_return(expression)
      allow(expression_text_parser).to receive(:validate_variable).with("y").and_return(true)
      allow(expression_text_parser).to receive(:validate_variable).with("t").and_return(true)
      allow(expression_stringifier).to receive(:stringify).with(expression).and_return("y")

      allow(expression_text_parser)
        .to receive(:validate_variable)
        .with("123invalid")
        .and_raise(SymDiffer::Error, "Invalid variable")

      allow(expression_text_parser)
        .to receive(:parse)
        .with("")
        .and_raise(SymDiffer::Error, "Invalid expression")

      allow(solution_approximator)
        .to receive(:approximate_solution)
        .with(
          an_object_having_attributes(
            expression:,
            undetermined_function_name: "y",
            variable_name: "t",
            initial_coordinates: coordinates(0, 1)
          ),
          step_range
        )
        .and_return(solution_approximation)

      allow(view_renderer).to receive(:render).and_return(rendered_view)
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:expression_text_parser) { double(:expression_text_parser) }
    let(:expression_stringifier) { double(:expression_stringifier) }
    let(:solution_approximator) { double(:solution_approximator) }
    let(:view_renderer) { double(:view_renderer) }
    let(:step_range) { double(:step_range) }

    let(:expression) { double(:expression) }
    let(:rendered_view) { double(:rendered_view) }

    context "when expression = y, y-var name = y, t-var name = x, initial value coordinates = (0, 1)" do
      let(:expression_text) { "y" }
      let(:undetermined_function_name) { "y" }
      let(:variable_name) { "t" }
      let(:initial_value_coordinates) { coordinates(0.0, 1.0) }

      let(:solution_approximation) do
        create_expression_path(
          [create_evaluation_point(0.0, 1.0),
           create_evaluation_point(1.0, 2.6)]
        )
      end

      let(:expected_evaluation_path) do
        an_object_having_attributes(
          evaluation_points: [same_evaluation_point_as(create_evaluation_point(-0.0, 1.0)),
                              same_evaluation_point_as(create_evaluation_point(1.0, 2.6))]
        )
      end

      it { expect(illustrate_approximation).to eq(rendered_view) }

      it "requests to render the expected abscissa axis" do
        illustrate_approximation

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            abscissa_axis: an_object_having_attributes(
              name: "t",
              number_labels: a_collection_including(0.0, 0.1, 0.2, 0.4, 0.5, 0.8, 0.9, 1.0),
              origin: 0.0
            )
          )
        )
      end

      it "requests to render the expected ordinate axis" do
        illustrate_approximation

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            ordinate_axis: an_object_having_attributes(
              name: "y",
              number_labels: a_collection_including(1.0, 1.16, 1.32, 1.48, 1.8, 1.96, 2.12, 2.44, 2.6),
              origin: 2.6
            )
          )
        )
      end

      it "requests to render the expected approximation solution curve" do
        illustrate_approximation

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            curves: a_collection_containing_exactly(
              an_object_having_attributes(
                text: "Expression: y",
                path: expected_evaluation_path
              )
            )
          )
        )
      end

      it "requests to render with the expected graph parameters" do
        illustrate_approximation

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            expression_graph_parameters: {
              max_abscissa_value: 1.0, min_abscissa_value: 0.0, abscissa_distance: 1.0,
              max_ordinate_value: 2.6, min_ordinate_value: 1.0, ordinate_distance: 1.6
            }
          )
        )
      end
    end

    context "when expression = , y-var name = y, t-var name = t, initial value coordinates = (0, 1)" do
      let(:expression_text) { "" }
      let(:undetermined_function_name) { "y" }
      let(:variable_name) { "t" }
      let(:initial_value_coordinates) { coordinates(0, 1) }

      let(:solution_approximation) { double(:solution_approximation) }

      it "lets SymDiffer::Error be raised" do
        expect { illustrate_approximation }.to raise_error(SymDiffer::Error, "Invalid expression")
      end
    end

    context "when expression = y, y-var name = 123invalid, t-var name = x, initial value coordinates = (0, 1)" do
      let(:expression_text) { "y" }
      let(:undetermined_function_name) { "123invalid" }
      let(:variable_name) { "x" }
      let(:initial_value_coordinates) { coordinates(0, 1) }

      let(:solution_approximation) { double(:solution_approximation) }

      it "lets SymDiffer::Error be raised" do
        expect { illustrate_approximation }.to raise_error(SymDiffer::Error, "Invalid variable")
      end
    end

    context "when expression = y, y-var name = y, t-var name = 123invalid, initial value coordinates = (0, 1)" do
      let(:expression_text) { "y" }
      let(:undetermined_function_name) { "y" }
      let(:variable_name) { "123invalid" }
      let(:initial_value_coordinates) { coordinates(0, 1) }

      let(:solution_approximation) { double(:solution_approximation) }

      it "lets SymDiffer::Error be raised" do
        expect { illustrate_approximation }.to raise_error(SymDiffer::Error, "Invalid variable")
      end
    end

    context "when expression = y, y-var name = <empty>, t-var name = <empty>, initial value coordinates = (0, 1)" do
      before do
        allow(solution_approximator)
          .to receive(:approximate_solution)
          .with(
            an_object_having_attributes(
              expression:,
              undetermined_function_name: "y",
              variable_name: "t",
              initial_coordinates: coordinates(0, 1)
            ),
            step_range
          )
          .and_return(solution_approximation)
      end

      let(:expression_text) { "y" }
      let(:undetermined_function_name) { "" }
      let(:variable_name) { "" }
      let(:initial_value_coordinates) { coordinates(0, 1) }

      let(:solution_approximation) do
        create_expression_path(
          [create_evaluation_point(0.0, 1.0),
           create_evaluation_point(1.0, 2.6)]
        )
      end

      it { is_expected.to eq(rendered_view) }
    end

    define_method(:coordinates) do |abscissa, ordinate|
      [abscissa, ordinate]
    end
  end
end
