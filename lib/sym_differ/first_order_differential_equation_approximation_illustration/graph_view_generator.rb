# frozen_string_literal: true

require "sym_differ/graphing/view"
require "sym_differ/graphing/axis_view"
require "sym_differ/graphing/expression_graph_view"

require "sym_differ/graphing/expression_path_scaler"

require "forwardable"

module SymDiffer
  module FirstOrderDifferentialEquationApproximationIllustration
    # Generates the view of the graphs for the approximated solution to the differential equation given by the equation
    # parameters.
    class GraphViewGenerator
      extend Forwardable

      def initialize(expression_stringifier)
        @expression_stringifier = expression_stringifier
      end

      def generate(approximation_expression_path, equation_parameters, expression_graph_parameters)
        @equation_parameters = equation_parameters
        @expression_graph_parameters = expression_graph_parameters

        abscissa_axis_view = generate_abscissa_axis_view
        ordinate_axis_view = generate_ordinate_axis_view

        approximation_graph_view = generate_expression_graph_view(approximation_expression_path)

        new_view(abscissa_axis_view, ordinate_axis_view, [approximation_graph_view])
      end

      private

      attr_reader :equation_parameters, :expression_graph_parameters

      def generate_abscissa_axis_view
        number_labels = produce_10_number_labels(min_abscissa_value, abscissa_distance / 10.0)

        origin = -scale_value_along_100_unit_axis(min_abscissa_value, abscissa_distance)

        new_axis_view(variable_name, number_labels, origin)
      end

      def generate_ordinate_axis_view
        distance_of_axis_to_draw, vertical_starting_point =
          ordinate_distance.zero? ? [1.0, 1.0] : [ordinate_distance, max_ordinate_value]

        numeric_gap = distance_of_axis_to_draw / 10.0
        number_labels = produce_10_number_labels(min_ordinate_value, numeric_gap)

        origin = scale_value_along_100_unit_axis(vertical_starting_point, distance_of_axis_to_draw)
        (origin += max_ordinate_value) if ordinate_distance.zero?

        new_axis_view(undetermined_function_name, number_labels, origin)
      end

      def generate_expression_graph_view(approximation_expression_path)
        stringified_expression = stringify_expression(expression)
        title = "Expression: #{stringified_expression}"

        scaled_expression_path = scale_path_to_target_sized_square(approximation_expression_path)

        new_expression_graph_view(title, scaled_expression_path)
      end

      def produce_10_number_labels(starting_value, numeric_gap)
        (0..10).map { |index| round_number_label(starting_value + (numeric_gap * index)) }
      end

      def round_number_label(number)
        number.round(3)
      end

      def max_ordinate_value
        expression_graph_parameters[:max_ordinate_value]
      end

      def min_ordinate_value
        expression_graph_parameters[:min_ordinate_value]
      end

      def ordinate_distance
        expression_graph_parameters[:ordinate_distance]
      end

      def max_abscissa_value
        expression_graph_parameters[:max_abscissa_value]
      end

      def min_abscissa_value
        expression_graph_parameters[:min_abscissa_value]
      end

      def abscissa_distance
        expression_graph_parameters[:abscissa_distance]
      end

      def stringify_expression(expression)
        @expression_stringifier.stringify(expression)
      end

      def scale_value_along_100_unit_axis(value, axis_distance)
        expression_path_scaler.scale_along_axis(value, axis_distance)
      end

      def scale_path_to_target_sized_square(expression_path)
        expression_path_scaler
          .scale_to_target_sized_square(expression_path, abscissa_distance, ordinate_distance)
      end

      def new_view(*)
        Graphing::View.new(*)
      end

      def new_axis_view(*)
        Graphing::AxisView.new(*)
      end

      def new_expression_graph_view(*)
        Graphing::ExpressionGraphView.new(*)
      end

      def expression_path_scaler
        @expression_path_scaler ||= Graphing::ExpressionPathScaler.new(100)
      end

      def_delegators :equation_parameters, :undetermined_function_name, :variable_name, :expression
    end
  end
end
