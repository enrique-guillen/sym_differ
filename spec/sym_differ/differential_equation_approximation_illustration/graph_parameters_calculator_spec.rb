# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differential_equation_approximation_illustration/graph_parameters_calculator"

require "sym_differ/differential_equation_approximation/equation_parameters"

RSpec.describe SymDiffer::DifferentialEquationApproximationIllustration::GraphParametersCalculator do
  describe "#calculate" do
    subject(:calculate) do
      described_class.new.calculate(approximation_expression_path)
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:approximation_expression_path) do
      create_expression_path(
        [create_evaluation_point(0.0, 1.0), create_evaluation_point(1.0, 2.6)]
      )
    end

    it "returns the expected parameters" do
      expect(calculate).to include(
        max_ordinate_value: 2.6, min_ordinate_value: 1.0, ordinate_distance: 1.6,
        max_abscissa_value: 1.0, min_abscissa_value: 0.0, abscissa_distance: 1.0
      )
    end
  end
end
