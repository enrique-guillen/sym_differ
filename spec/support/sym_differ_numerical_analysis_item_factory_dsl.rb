# frozen_string_literal: true

require "sym_differ/numerical_analysis_item_factory"

module Support
  # Defines DSL methods that create objects via the NumericalAnalysisItemFactory protocol/interface. Allows
  # redefining what the concrete factory is that responds to the methods.
  module SymDifferNumericalAnalysisItemFactoryDsl
    def sym_differ_numerical_analysis_item_factory
      SymDiffer::NumericalAnalysisItemFactory.new
    end

    def create_step_range(*)
      numerical_analysis_item_factory.create_step_range(*)
    end

    def create_evaluation_point(*)
      numerical_analysis_item_factory.create_evaluation_point(*)
    end
  end
end
