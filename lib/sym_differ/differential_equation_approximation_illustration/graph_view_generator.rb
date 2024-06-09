# frozen_string_literal: true

require "sym_differ/graphing/view"
require "sym_differ/graphing/axis_view"
require "sym_differ/graphing/expression_graph_view"

require "forwardable"

module SymDiffer
  module DifferentialEquationApproximationIllustration
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

        new_view(abscissa_axis_view, ordinate_axis_view, [approximation_graph_view], expression_graph_parameters)
      end

      private

      attr_reader :equation_parameters, :expression_graph_parameters

      def generate_abscissa_axis_view
        numeric_gap = abscissa_distance / 10.0
        number_labels = produce_10_number_labels(min_abscissa_value, numeric_gap)

        origin = min_abscissa_value

        new_axis_view(variable_name, number_labels, origin)
      end

      def generate_ordinate_axis_view
        distance_of_axis_to_draw = ordinate_distance.zero? ? 1.0 : ordinate_distance

        numeric_gap = distance_of_axis_to_draw / 10.0
        number_labels = produce_10_number_labels(min_ordinate_value, numeric_gap)

        new_axis_view(undetermined_function_name, number_labels, max_ordinate_value)
      end

      def generate_expression_graph_view(approximation_expression_path)
        stringified_expression = stringify_expression(expression)
        title = "Expression: #{stringified_expression}"

        new_expression_graph_view(title, approximation_expression_path)
      end

      def produce_10_number_labels(starting_value, numeric_gap)
        (0..10).map { |index| starting_value + (numeric_gap * index) }
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

      def min_abscissa_value
        expression_graph_parameters[:min_abscissa_value]
      end

      def abscissa_distance
        expression_graph_parameters[:abscissa_distance]
      end

      def stringify_expression(expression)
        @expression_stringifier.stringify(expression)
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

      def_delegators :equation_parameters, :undetermined_function_name, :variable_name, :expression
    end
  end
end
