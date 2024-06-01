# frozen_string_literal: true

require "sym_differ/fixed_point_approximator"

module SymDiffer
  module DifferentiationVisualization
    # Allows dynamic creation of the FixedPointApproximator.
    class FixedPointFinderFactory
      def create(expression_evaluator)
        FixedPointApproximator.new(0.00001, 100, expression_evaluator)
      end
    end
  end
end
