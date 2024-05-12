# frozen_string_literal: true

require "sym_differ/differentiation_graph/step_range"

module SymDiffer
  module DifferentiationGraph
    # Outputs information about the expression graphs that must be honored regardless of view size.
    class ExpressionGraphParametersCalculator
      def initialize(variable, expression_path_generator)
        @variable = variable
        @expression_path_generator = expression_path_generator
      end

      def calculate(expression, derivative_expression)
        expression_path = generate_expression_path(expression, build_step_range(-10.0..10.0))
        derivative_expression_path = generate_expression_path(derivative_expression, build_step_range(-10.0..10.0))

        max_ordinate_value = max_value_from_expression_paths(expression_path, derivative_expression_path)
        min_ordinate_value = min_value_from_expression_paths(expression_path, derivative_expression_path)
        ordinate_distance = max_ordinate_value - min_ordinate_value

        { expression_path:, derivative_expression_path:, max_ordinate_value:, min_ordinate_value:, ordinate_distance: }
      end

      private

      def max_value_from_expression_paths(*paths)
        paths
          .flat_map { |path| path.map(&:ordinate) }
          .max
      end

      def min_value_from_expression_paths(*paths)
        paths
          .flat_map { |path| path.map(&:ordinate) }
          .min
      end

      def generate_expression_path(expression, step_range)
        @expression_path_generator.generate(expression, @variable, step_range)
      end

      def build_step_range(range)
        StepRange.new(range)
      end
    end
  end
end
