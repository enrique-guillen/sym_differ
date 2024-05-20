# frozen_string_literal: true

require "sym_differ/numerical_analysis/step_range"
require "sym_differ/numerical_analysis/evaluation_point"

module SymDiffer
  # Builds parameters and output objects of numerical analysis processes.
  class NumericalAnalysisItemFactory
    def create_step_range(range)
      NumericalAnalysis::StepRange.new(range)
    end

    def create_evaluation_point(abscissa, ordinate)
      NumericalAnalysis::EvaluationPoint.new(abscissa, ordinate)
    end
  end
end
