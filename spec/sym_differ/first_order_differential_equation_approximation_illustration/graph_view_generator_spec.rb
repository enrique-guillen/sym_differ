# frozen_string_literal: true

require "spec_helper"
require "sym_differ/first_order_differential_equation_approximation_illustration/graph_view_generator"

require "sym_differ/first_order_differential_equation_solution/equation_parameters"

RSpec.describe SymDiffer::FirstOrderDifferentialEquationApproximationIllustration::GraphViewGenerator do
  describe "#generate" do
    subject(:generate) do
      described_class
        .new(expression_stringifier)
        .generate(approximation_expression_path, equation_parameters, expression_graph_parameters)
    end

    before do
      allow(expression_stringifier)
        .to receive(:stringify)
        .with(expression)
        .and_return("y")
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:expression_stringifier) { double(:expression_stringifier) }

    let(:equation_parameters) do
      SymDiffer::FirstOrderDifferentialEquationSolution::EquationParameters
        .new(expression, "y", "t", [0.0, 0.1])
    end

    let(:expression) { double(:expression) }

    context "when expression_graph_parameters[:ordinate_distance] != 0" do
      let(:approximation_expression_path) do
        create_expression_path(
          [create_evaluation_point(-1.0, 1.0),
           create_evaluation_point(0.0, 2.6)]
        )
      end

      let(:expression_graph_parameters) do
        {
          max_ordinate_value: 2.6, min_ordinate_value: 1.0, ordinate_distance: 1.6,
          max_abscissa_value: 0.0, min_abscissa_value: -1.0, abscissa_distance: 1.0
        }
      end

      let(:scaled_approximation_expression_path) do
        [same_evaluation_point_as(create_evaluation_point(-1.0, 1.0)),
         same_evaluation_point_as(create_evaluation_point(0.0, 2.6))]
      end

      it "returns the expected curves" do
        expect(generate).to have_attributes(
          curves: a_collection_containing_exactly(
            an_object_having_attributes(
              text: "Expression: y",
              path: an_object_having_attributes(
                evaluation_points: a_collection_containing_exactly(*scaled_approximation_expression_path)
              )
            )
          )
        )
      end

      it "returns the expected abscissa axis" do
        expect(generate).to have_attributes(
          abscissa_axis: an_object_having_attributes(
            name: "t", origin: -1.0,
            number_labels: include(-1.0, -0.9, -0.8, -0.7, -0.6, -0.5, 0.0)
          )
        )
      end

      it "returns the expected ordinate axis" do
        expect(generate).to have_attributes(
          ordinate_axis: an_object_having_attributes(
            name: "y", origin: 2.6,
            number_labels: [1.0, 1.16, 1.32, 1.48, 1.6400000000000001,
                            1.8, 1.96, 2.12, 2.2800000000000002, 2.44, 2.6]
          )
        )
      end
    end

    context "when expression_graph_parameters[:ordinate_distance] = 0" do
      let(:approximation_expression_path) do
        create_expression_path(
          [create_evaluation_point(-1.0, 2.6),
           create_evaluation_point(0.0, 2.6)]
        )
      end

      let(:expression_graph_parameters) do
        {
          max_ordinate_value: 2.6, min_ordinate_value: 2.6, ordinate_distance: 0.0,
          max_abscissa_value: 0.0, min_abscissa_value: -1.0, abscissa_distance: 1.0
        }
      end

      let(:scaled_approximation_expression_path) do
        [same_evaluation_point_as(create_evaluation_point(-1.0, 2.6)),
         same_evaluation_point_as(create_evaluation_point(0.0, 2.6))]
      end

      it "returns the expected abscissa_axis" do
        expect(generate).to have_attributes(
          abscissa_axis: an_object_having_attributes(
            name: "t",
            origin: -1.0,
            number_labels: a_collection_including(-1.0, -0.9, -0.8, -0.7, -0.6, -0.5, 0.0)
          )
        )
      end

      it "returns the expected ordinate_axis" do
        expect(generate).to have_attributes(
          ordinate_axis: an_object_having_attributes(
            name: "y",
            origin: 2.6,
            number_labels: [
              2.6, 2.7, 2.8000000000000003, 2.9000000000000004, 3.0, 3.1,
              3.2, 3.3000000000000003, 3.4000000000000004, 3.5, 3.6
            ]
          )
        )
      end

      it "returns the expected curves" do
        expect(generate).to have_attributes(
          curves: a_collection_containing_exactly(
            an_object_having_attributes(
              text: "Expression: y",
              path: an_object_having_attributes(
                evaluation_points: a_collection_containing_exactly(*scaled_approximation_expression_path)
              )
            )
          )
        )
      end
    end
  end
end
