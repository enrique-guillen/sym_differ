# frozen_string_literal: true

require "spec_helper"
require "sym_differ/get_first_order_differential_equation_approximation_interactor"

RSpec.describe SymDiffer::GetFirstOrderDifferentialEquationApproximationInteractor do
  describe "#approximate_solution" do
    subject(:approximate_solution) do
      described_class.new.approximate_solution(
        expression_text, undetermined_function_name, variable_name, initial_value_coordinates
      )
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:expression_text) { "y" }
    let(:undetermined_function_name) { "y" }
    let(:variable_name) { "x" }

    context "when initial coordinates = 0.0, 1.0" do
      let(:initial_value_coordinates) { coordinates(0.0, 1.0) }

      it "returns the expected approximate solution" do
        expect(approximate_solution).to have_attributes(
          approximated_solution: a_collection_including(
            same_evaluation_point_as(create_evaluation_point(0.0, 1.0)),
            same_evaluation_point_as(create_evaluation_point(0.125, 1.1271974540051117)),
            same_evaluation_point_as(create_evaluation_point(1.0, 2.6061535098540802)),
            same_evaluation_point_as(create_evaluation_point(5.0, 120.22643420198703)),
            same_evaluation_point_as(create_evaluation_point(10.0, 14_454.395480924717))
          )
        )
      end
    end

    context "when initial coordinates = 1.0, <Math::E>" do
      let(:initial_value_coordinates) { coordinates(1.0, Math::E) }

      it "returns the expected approximate solution" do
        expect(approximate_solution).to have_attributes(
          approximated_solution: a_collection_including(
            same_evaluation_point_as(create_evaluation_point(1.0, Math::E)),
            same_evaluation_point_as(create_evaluation_point(1.125, 3.0640403563073955)),
            same_evaluation_point_as(create_evaluation_point(6.0, 326.80933139168866)),
            same_evaluation_point_as(create_evaluation_point(11.0, 39_291.120577158246))
          )
        )
      end
    end

    define_method(:coordinates) do |abscissa, ordinate|
      [abscissa, ordinate]
    end
  end
end
