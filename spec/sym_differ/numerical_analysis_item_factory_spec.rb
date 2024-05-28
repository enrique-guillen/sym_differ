# frozen_string_literal: true

require "spec_helper"
require "sym_differ/numerical_analysis_item_factory"

require "sym_differ/numerical_analysis/step_range"
require "sym_differ/numerical_analysis/evaluation_point"
require "sym_differ/numerical_analysis/expression_path"

RSpec.describe SymDiffer::NumericalAnalysisItemFactory do
  describe "#create_step_range" do
    subject(:create_step_range) do
      described_class.new.create_step_range(range)
    end

    let(:range) { 0..10 }

    it "returns the expected step range" do
      expect(create_step_range)
        .to be_a(SymDiffer::NumericalAnalysis::StepRange)
        .and have_attributes(minimum: 0, maximum: 10)
    end
  end

  describe "#create_evaluation_point" do
    subject(:create_evaluation_point) do
      described_class.new.create_evaluation_point(2, 3)
    end

    it "returns the expected evaluation point" do
      expect(create_evaluation_point)
        .to be_a(SymDiffer::NumericalAnalysis::EvaluationPoint)
        .and have_attributes(abscissa: 2, ordinate: 3)
    end
  end

  describe "#create_expression_path" do
    subject(:create_expression_path) do
      factory
        .create_expression_path([evaluation_point])
    end

    let(:factory) { described_class.new }
    let(:evaluation_point) { factory.create_evaluation_point(2, 3) }

    it "returns the expected evaluation path" do
      expect(create_expression_path)
        .to be_a(SymDiffer::NumericalAnalysis::ExpressionPath)
        .and have_attributes(evaluation_points: [same_evaluation_point_as(evaluation_point)])
    end
  end
end
