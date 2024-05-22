# frozen_string_literal: true

require "spec_helper"
require "sym_differ/illustrate_differential_equation_approximation_interactor"

RSpec.describe SymDiffer::IllustrateDifferentialEquationApproximationInteractor do
  describe "#illustrate_approximation" do
    subject(:illustrate_approximation) do
      described_class
        .new(view_renderer)
        .illustrate_approximation(expression_text, undetermined_function_name, variable_name, initial_value_coordinates)
    end

    before { allow(view_renderer).to receive(:render).and_return(rendered_view) }

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:view_renderer) { double(:view_renderer) }

    let(:expression_text) { "y" }
    let(:undetermined_function_name) { "y" }
    let(:variable_name) { "x" }

    let(:rendered_view) { double(:rendered_view) }

    context "when initial coordinates = 0.0, 1.0" do
      let(:initial_value_coordinates) { coordinates(0.0, 1.0) }

      let(:expected_evaluation_points) do
        [create_evaluation_point(0.0, 1.0), create_evaluation_point(0.125, 1.1271974540051117),
         create_evaluation_point(0.5, 1.6143585443928121), create_evaluation_point(1.0, 2.6061535098540802),
         create_evaluation_point(5.0, 120.22643420198703), create_evaluation_point(10.0, 14_454.395480924717)]
      end

      it { is_expected.to have_attributes(image: rendered_view) }

      it "renders the expected abscissa axis" do
        illustrate_approximation

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            abscissa_axis: an_object_having_attributes(
              name: "x", origin: 0.0,
              number_labels: [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
            )
          )
        )
      end

      it "renders the expected ordinate axis" do
        illustrate_approximation

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            ordinate_axis: an_object_having_attributes(
              name: "y", origin: 14_454.395480924717,
              number_labels: [
                1.0, 1446.3395480924717, 2891.6790961849433, 4337.018644277415, 5782.358192369887, 7227.6977404623585,
                8673.03728855483, 10_118.376836647301, 11_563.716384739773, 13_009.055932832245, 14_454.395480924717
              ]
            )
          )
        )
      end

      it "renders the expected derivative expression graph" do
        illustrate_approximation

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            curves: a_collection_including(
              an_object_having_attributes(
                text: "Expression: y",
                path: a_collection_including(*expected_evaluation_points.map(&method(:same_evaluation_point_as)))
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
              max_abscissa_value: 10.0, min_abscissa_value: 0.0, abscissa_distance: 10.0,
              max_ordinate_value: 14_454.395480924717, min_ordinate_value: 1.0, ordinate_distance: 14_453.395480924717
            }
          )
        )
      end
    end

    context "when initial coordinates = 1.0, <Math::E>" do
      let(:initial_value_coordinates) { coordinates(1.0, Math::E) }

      let(:expected_evaluation_points) do
        [
          create_evaluation_point(1.0, 2.718281828459045),
          create_evaluation_point(1.125, 3.0640403563073955),
          create_evaluation_point(1.25, 3.453778488598612),
          create_evaluation_point(1.5, 4.388281495840576),
          create_evaluation_point(2.0, 7.084259728011107),
          create_evaluation_point(6.0, 326.80933139168866),
          create_evaluation_point(11.0, 39_291.120577158246)
        ]
      end

      it { is_expected.to have_attributes(image: rendered_view) }

      it "renders the expected derivative expression graph" do
        illustrate_approximation

        expect(view_renderer).to have_received(:render).with(
          an_object_having_attributes(
            curves: a_collection_including(
              an_object_having_attributes(
                text: "Expression: y",
                path: a_collection_including(*expected_evaluation_points.map(&method(:same_evaluation_point_as)))
              )
            )
          )
        )
      end
    end

    define_method(:coordinates) do |abscissa, ordinate|
      [abscissa, ordinate]
    end
  end
end
