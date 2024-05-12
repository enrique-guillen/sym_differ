# frozen_string_literal: true

require "sym_differ/differentiation_graph/step_range"
require "sym_differ/differentiation_graph/evaluation_point"
require "sym_differ/differentiation_graph/view"

require "sym_differ/differentiation_graph/expression_path_scaler"

module SymDiffer
  module DifferentiationGraph
    # Generates the view of the graphs for an expression and its derivative.
    class GraphViewGenerator
      # View of the graphs for an expression and its derivative.
      def initialize(variable, expression_stringifier, expression_path_generator)
        @variable = variable
        @expression_stringifier = expression_stringifier
        @expression_path_generator = expression_path_generator
      end

      def generate(expression, derivative_expression)
        expression_path = generate_expression_path(expression, StepRange.new(-10.0..10.0))
        derivative_expression_path = generate_expression_path(derivative_expression, StepRange.new(-10.0..10.0))

        max_value = max_value_from_expression_paths(expression_path, derivative_expression_path)
        min_value = min_value_from_expression_paths(expression_path, derivative_expression_path)
        distance = max_value - min_value

        View.new(false, @variable, "y", *stringified_expressions(expression, derivative_expression),
                 scale_to_100_unit_square(expression_path, distance),
                 scale_to_100_unit_square(derivative_expression_path, distance),
                 *abscissas_labels_and_positioning,
                 *ordinate_labels_and_positioning(min_value, max_value, distance))
      end

      private

      def generate_expression_path(expression, step_range)
        @expression_path_generator.generate(expression, @variable, step_range)
      end

      def max_value_from_expression_paths(*paths)
        paths
          .flat_map { |path| path.map(&method(:evaluate_point_ordinate)) }
          .max
      end

      def min_value_from_expression_paths(*paths)
        paths
          .flat_map { |path| path.map(&method(:evaluate_point_ordinate)) }
          .min
      end

      def stringified_expressions(expression, derivative_expression)
        stringified_expression = stringify_expression(expression)
        stringified_derivative_expression = stringify_expression(derivative_expression)

        [stringified_expression, stringified_derivative_expression]
      end

      def scale_to_100_unit_square(expression_path, ordinate_axis_distance)
        abscissa_axis_distance = 20

        expression_path_scaler_size_100
          .scale_to_target_sized_square(expression_path, abscissa_axis_distance, ordinate_axis_distance)
      end

      def abscissas_labels_and_positioning
        abscissa_number_labels = [-10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0]
        origin_abscissa = 50
        abscissa_offset = 0.0

        [abscissa_number_labels, origin_abscissa, abscissa_offset]
      end

      def ordinate_labels_and_positioning(min_value, max_value, distance)
        origin_ordinate = (max_value * 100) / distance

        ordinate_offset = 0.0
        ordinate_label_gap = distance / 10.0

        ordinate_number_labels = (0..10).map { |i| (min_value + (ordinate_label_gap * i)).round(3) }

        [ordinate_number_labels, origin_ordinate, ordinate_offset]
      end

      def evaluate_point_ordinate(point)
        point.ordinate
      end

      def stringify_expression(expression)
        @expression_stringifier.stringify(expression)
      end

      def expression_path_scaler_size_100
        @expression_path_scaler_size_100 ||= ExpressionPathScaler.new(100)
      end
    end
  end
end
