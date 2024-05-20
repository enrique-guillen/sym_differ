# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_graph/expression_path_scaler"

RSpec.describe SymDiffer::DifferentiationGraph::ExpressionPathScaler do
  describe "#scale_to_target_sized_square" do
    subject(:scale_to_target_sized_square) do
      described_class
        .new(100)
        .scale_to_target_sized_square(expression_path, abscissa_axis_distance, ordinate_axis_distance)
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:variable) { "x" }
    let(:expression_stringifier) { double(:expression_stringifier) }
    let(:expression_path_generator) { double(:expression_path_generator) }

    context "when the ordinate distance is 95" do
      let(:abscissa_axis_distance) { 20.0 }
      let(:ordinate_axis_distance) { 95.0 }

      let(:expression_path) do
        [create_evaluation_point(-10.0, -60.0),
         create_evaluation_point(0.0, 30.0),
         create_evaluation_point(10.0, 35.0)]
      end

      it "returns the evaluation points scaled down by the distance/100 factor" do
        expect(scale_to_target_sized_square).to contain_exactly(
          same_evaluation_point_as(create_evaluation_point(-50.0, -63.1578947368421)),
          same_evaluation_point_as(create_evaluation_point(0.0, 31.57894736842105)),
          same_evaluation_point_as(create_evaluation_point(50.0, 36.84210526315789))
        )
      end
    end

    context "when the ordinate distance is 0" do
      let(:abscissa_axis_distance) { 20.0 }
      let(:ordinate_axis_distance) { 0.0 }

      let(:expression_path) do
        [create_evaluation_point(-10.0, 35.0),
         create_evaluation_point(0.0, 35.0),
         create_evaluation_point(10.0, 35.0)]
      end

      it "returns the evaluation points without ordinate scaling" do
        expect(scale_to_target_sized_square).to contain_exactly(
          same_evaluation_point_as(create_evaluation_point(-50.0, 35.0)),
          same_evaluation_point_as(create_evaluation_point(0.0, 35.0)),
          same_evaluation_point_as(create_evaluation_point(50.0, 35.0))
        )
      end
    end
  end
end
