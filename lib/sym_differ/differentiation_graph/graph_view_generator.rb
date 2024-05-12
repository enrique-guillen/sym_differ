# frozen_string_literal: true

require "sym_differ/differentiation_graph/step_range"
require "sym_differ/differentiation_graph/evaluation_point"

require "sym_differ/differentiation_graph/view"
require "sym_differ/differentiation_graph/expression_graph_view"
require "sym_differ/differentiation_graph/axis_view"

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
        expression_path = generate_expression_path(expression, build_step_range(-10.0..10.0))
        derivative_expression_path = generate_expression_path(derivative_expression, build_step_range(-10.0..10.0))

        max_value = max_value_from_expression_paths(expression_path, derivative_expression_path)
        min_value = min_value_from_expression_paths(expression_path, derivative_expression_path)
        distance = max_value - min_value

        abscissa_axis_view = generate_abscissa_axis_view
        ordinate_axis_view = generate_ordinate_axis_view(min_value, max_value, distance)

        expression_graph_view =
          generate_expression_graph_view(expression, expression_path, distance)
        derivative_expression_graph_view =
          generate_expression_graph_view(derivative_expression, derivative_expression_path, distance)

        new_view(false, abscissa_axis_view, ordinate_axis_view, expression_graph_view, derivative_expression_graph_view)
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

      def generate_abscissa_axis_view
        new_axis_view(@variable, *abscissas_labels_and_positioning)
      end

      def generate_ordinate_axis_view(min_value, max_value, distance)
        new_axis_view("y", *ordinate_labels_and_positioning(min_value, max_value, distance))
      end

      def generate_expression_graph_view(expression, expression_path, distance)
        stringified_expression = stringify_expression(expression)
        scaled_expression_path = scale_to_100_unit_square(expression_path, distance)

        new_expression_graph_view(stringified_expression, scaled_expression_path)
      end

      def scale_to_100_unit_square(expression_path, ordinate_axis_distance)
        abscissa_axis_distance = 20

        expression_path_scaler
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

      def generate_expression_path(expression, step_range)
        @expression_path_generator.generate(expression, @variable, step_range)
      end

      def new_view(*args)
        View.new(*args)
      end

      def new_expression_graph_view(*args)
        ExpressionGraphView.new(*args)
      end

      def new_axis_view(*args)
        AxisView.new(*args)
      end

      def build_step_range(range)
        StepRange.new(range)
      end

      def expression_path_scaler
        @expression_path_scaler ||= ExpressionPathScaler.new(100)
      end

      def stringify_expression(expression)
        @expression_stringifier.stringify(expression)
      end
    end
  end
end
