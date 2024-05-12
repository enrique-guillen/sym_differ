# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_graph/expression_path_scaler"

require "sym_differ/differentiation_graph/evaluation_point"

RSpec.describe SymDiffer::DifferentiationGraph::ExpressionPathScaler do
  describe "#scale_to_target_sized_square" do
    subject(:scale_to_target_sized_square) do
      described_class
        .new(100)
        .scale_to_target_sized_square(expression_path, abscissa_axis_distance, ordinate_axis_distance)
    end

    let(:variable) { "x" }
    let(:expression_stringifier) { double(:expression_stringifier) }
    let(:expression_path_generator) { double(:expression_path_generator) }

    let(:expression_path) do
      [evaluation_point(-10.0, -60.0),
       evaluation_point(0.0, 30.0),
       evaluation_point(10.0, 40.0)]
    end

    let(:abscissa_axis_distance) { 20 }
    let(:ordinate_axis_distance) { 100 }

    it "returns the evaluation points scaled down by the distance/100 factor" do
      expect(scale_to_target_sized_square).to contain_exactly(
        same_evaluation_point_as(evaluation_point(-50.0, -60.0)),
        same_evaluation_point_as(evaluation_point(0.0, 30.0)),
        same_evaluation_point_as(evaluation_point(50.0, 40.0))
      )
    end
  end

  define_method(:evaluation_point) do |abscissa, ordinate|
    SymDiffer::DifferentiationGraph::EvaluationPoint.new(abscissa, ordinate)
  end
end
