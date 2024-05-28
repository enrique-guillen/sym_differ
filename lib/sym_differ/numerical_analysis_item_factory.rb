# frozen_string_literal: true

require "sym_differ/numerical_analysis/step_range"
require "sym_differ/numerical_analysis/evaluation_point"
require "sym_differ/numerical_analysis/expression_path"

module SymDiffer
  # Builds parameters and output objects of numerical analysis processes.
  class NumericalAnalysisItemFactory
    def create_step_range(range)
      NumericalAnalysis::StepRange.new(range)
    end

    def create_evaluation_point(abscissa, ordinate)
      NumericalAnalysis::EvaluationPoint.new(abscissa, ordinate)
    end

    def create_expression_path(evaluation_points)
      NumericalAnalysis::ExpressionPath.new(evaluation_points)
    end
  end
end
