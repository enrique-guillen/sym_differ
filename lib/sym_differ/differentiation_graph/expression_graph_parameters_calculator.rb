# frozen_string_literal: true

module SymDiffer
  module DifferentiationGraph
    # Outputs information about the expression graphs that must be honored regardless of view size.
    class ExpressionGraphParametersCalculator
      def initialize(variable, expression_path_generator, step_range)
        @variable = variable
        @expression_path_generator = expression_path_generator
        @step_range = step_range
      end

      def calculate(expression, derivative_expression)
        expression_path = generate_expression_path(expression, @step_range)
        derivative_expression_path = generate_expression_path(derivative_expression, @step_range)

        build_expression_path_parameters(expression_path, derivative_expression_path)
          .merge(generate_abscissa_parameters(expression_path, derivative_expression_path))
          .merge(generate_ordinate_parameters(expression_path, derivative_expression_path))
      end

      private

      def build_expression_path_parameters(expression_path, derivative_expression_path)
        { expression_path:, derivative_expression_path: }
      end

      def generate_abscissa_parameters(expression_path, derivative_expression_path)
        max_abscissa_value = max_abscissa_value_from_expression_paths(expression_path, derivative_expression_path)
        min_abscissa_value = min_abscissa_value_from_expression_paths(expression_path, derivative_expression_path)
        abscissa_distance = max_abscissa_value - min_abscissa_value

        { max_abscissa_value:, min_abscissa_value:, abscissa_distance: }
      end

      def generate_ordinate_parameters(expression_path, derivative_expression_path)
        max_ordinate_value = max_value_from_expression_paths(expression_path, derivative_expression_path)
        min_ordinate_value = min_value_from_expression_paths(expression_path, derivative_expression_path)
        ordinate_distance = max_ordinate_value - min_ordinate_value

        { max_ordinate_value:, min_ordinate_value:, ordinate_distance: }
      end

      def max_value_from_expression_paths(*paths)
        paths
          .flat_map(&:max_ordinate_value)
          .compact
          .max
      end

      def min_value_from_expression_paths(*paths)
        paths
          .flat_map(&:min_ordinate_value)
          .compact
          .min
      end

      def max_abscissa_value_from_expression_paths(*paths)
        paths
          .flat_map(&:max_abscissa_value)
          .compact
          .max
      end

      def min_abscissa_value_from_expression_paths(*paths)
        paths
          .flat_map(&:min_abscissa_value)
          .compact
          .min
      end

      def generate_expression_path(expression, step_range)
        @expression_path_generator.generate(expression, @variable, step_range)
      end
    end
  end
end
