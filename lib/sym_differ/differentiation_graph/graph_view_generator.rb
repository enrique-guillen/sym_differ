# frozen_string_literal: true

require "sym_differ/graphing/view"
require "sym_differ/graphing/expression_graph_view"
require "sym_differ/graphing/axis_view"

require "sym_differ/graphing/expression_path_scaler"

module SymDiffer
  module DifferentiationGraph
    # Generates the view of the graphs for an expression and its derivative.
    class GraphViewGenerator
      # View of the graphs for an expression and its derivative.
      def initialize(variable, expression_stringifier)
        @variable = variable
        @expression_stringifier = expression_stringifier
      end

      def generate(expression, derivative_expression, expression_graph_parameters = {})
        @expression_graph_parameters = expression_graph_parameters

        new_expression_path = expression_path
        new_derivative_expression_path = derivative_expression_path

        abscissa_axis_view = generate_abscissa_axis_view
        ordinate_axis_view = generate_ordinate_axis_view

        expression_graph_view = generate_original_expression_graph_view(expression, new_expression_path)

        derivative_expression_graph_view =
          generate_derivative_expression_graph_view(derivative_expression, new_derivative_expression_path)

        new_view(abscissa_axis_view, ordinate_axis_view, [expression_graph_view, derivative_expression_graph_view],
                 expression_graph_parameters)
      end

      private

      attr_reader :expression_graph_parameters

      def generate_abscissa_axis_view
        new_axis_view(@variable, *abscissas_labels_and_positioning)
      end

      def generate_ordinate_axis_view
        new_axis_view("y", *ordinate_labels_and_positioning)
      end

      def generate_original_expression_graph_view(expression, expression_path)
        stringified_expression = "Expression: #{stringify_expression(expression)}"

        new_expression_graph_view(stringified_expression, expression_path)
      end

      def generate_derivative_expression_graph_view(expression, expression_path)
        stringified_expression = "Derivative: #{stringify_expression(expression)}"

        new_expression_graph_view(stringified_expression, expression_path)
      end

      def abscissas_labels_and_positioning
        distance_of_axis_to_draw = 20.0

        origin_abscissa = 10.0

        abscissa_label_gap = distance_of_axis_to_draw / 10.0
        abscissa_number_labels = produce_10_number_labels(-10, abscissa_label_gap)

        [abscissa_number_labels, -origin_abscissa]
      end

      def ordinate_labels_and_positioning
        distance_of_axis_to_draw = ordinate_distance.zero? ? 1.0 : ordinate_distance

        origin_ordinate = max_value

        ordinate_label_gap = distance_of_axis_to_draw / 10.0
        ordinate_number_labels = produce_10_number_labels(min_value, ordinate_label_gap)

        [ordinate_number_labels, origin_ordinate]
      end

      def produce_10_number_labels(starting_value, numeric_gap)
        (0..10).map { |i| starting_value + (numeric_gap * i) }
      end

      def round_number_label(number)
        number.round(3)
      end

      def expression_path
        expression_graph_parameters[:expression_path]
      end

      def derivative_expression_path
        expression_graph_parameters[:derivative_expression_path]
      end

      def max_value
        expression_graph_parameters[:max_ordinate_value]
      end

      def min_value
        expression_graph_parameters[:min_ordinate_value]
      end

      def ordinate_distance
        expression_graph_parameters[:ordinate_distance]
      end

      def abscissa_axis_distance
        20
      end

      def scale_expression_path_to_100_unit_square(expression_path,
                                                   axis_distance_1 = abscissa_axis_distance,
                                                   axis_distance_2 = ordinate_distance)
        expression_path_scaler
          .scale_to_target_sized_square(expression_path, axis_distance_1, axis_distance_2)
      end

      def scale_value_along_100_unit_axis(value, axis_distance)
        expression_path_scaler.scale_along_axis(value, axis_distance)
      end

      def new_view(*)
        Graphing::View.new(*)
      end

      def new_expression_graph_view(*)
        Graphing::ExpressionGraphView.new(*)
      end

      def new_axis_view(*)
        Graphing::AxisView.new(*)
      end

      def expression_path_scaler
        @expression_path_scaler ||= Graphing::ExpressionPathScaler.new(100)
      end

      def stringify_expression(expression)
        @expression_stringifier.stringify(expression)
      end
    end
  end
end
