# frozen_string_literal: true

require "sym_differ/differentiation_graph/view"
require "sym_differ/differentiation_graph/expression_graph_view"
require "sym_differ/differentiation_graph/axis_view"

require "sym_differ/differentiation_graph/expression_path_scaler"

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

        expression_graph_view =
          generate_expression_graph_view(expression, new_expression_path)
        derivative_expression_graph_view =
          generate_expression_graph_view(derivative_expression, new_derivative_expression_path)

        new_view(false, abscissa_axis_view, ordinate_axis_view, expression_graph_view, derivative_expression_graph_view)
      end

      private

      attr_reader :expression_graph_parameters

      def generate_abscissa_axis_view
        new_axis_view(@variable, *abscissas_labels_and_positioning)
      end

      def generate_ordinate_axis_view
        new_axis_view("y", *ordinate_labels_and_positioning)
      end

      def generate_expression_graph_view(expression, expression_path)
        stringified_expression = stringify_expression(expression)
        scaled_expression_path = scale_to_100_unit_square(expression_path)

        new_expression_graph_view(stringified_expression, scaled_expression_path)
      end

      def scale_to_100_unit_square(expression_path)
        abscissa_axis_distance = 20

        expression_path_scaler
          .scale_to_target_sized_square(expression_path, abscissa_axis_distance, ordinate_distance)
      end

      def abscissas_labels_and_positioning
        abscissa_number_labels = [-10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0]
        origin_abscissa = 50
        abscissa_offset = 0.0

        [abscissa_number_labels, origin_abscissa, abscissa_offset]
      end

      def ordinate_labels_and_positioning
        origin_ordinate = (max_value * 100) / ordinate_distance

        ordinate_offset = 0.0
        ordinate_label_gap = ordinate_distance / 10.0

        ordinate_number_labels = (0..10).map { |i| (min_value + (ordinate_label_gap * i)).round(3) }

        [ordinate_number_labels, origin_ordinate, ordinate_offset]
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

      def new_view(*)
        View.new(*)
      end

      def new_expression_graph_view(*)
        ExpressionGraphView.new(*)
      end

      def new_axis_view(*)
        AxisView.new(*)
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
