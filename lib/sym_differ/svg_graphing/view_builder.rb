# frozen_string_literal: true

require "sym_differ/svg_graphing/view"
require "sym_differ/graphing/expression_path_scaler"

require "sym_differ/graphing/view"
require "sym_differ/graphing/axis_view"
require "sym_differ/graphing/expression_graph_view"

require "forwardable"

module SymDiffer
  module SvgGraphing
    # Creates this module's View, which contains a homogenized set of SVG values that produce the desired SVG when
    # plugged into the corresponding template, adapting its contents to the contents of the original Graphing::View.
    class ViewBuilder
      extend Forwardable

      def initialize(numerical_analysis_item_factory)
        @numerical_analysis_item_factory = numerical_analysis_item_factory
      end

      def build(original_view, curve_stylings)
        @original_view = original_view

        abscissa_axis = generate_abscissa_axis_view
        ordinate_axis = generate_ordinate_axis_view
        curves = calculate_new_curves

        graphing_view = new_graphing_view(abscissa_axis, ordinate_axis, curves)

        new_view(false, graphing_view, curve_stylings)
      end

      private

      def generate_abscissa_axis_view
        origin = -scale_value_along_100_unit_axis(original_view.abscissa_axis.origin, abscissa_distance)

        new_axis_view(original_view.abscissa_axis.name, original_view.abscissa_axis.number_labels, origin)
      end

      def generate_ordinate_axis_view
        vertical_starting_point, ordinate_distance_to_draw =
          ordinate_distance.zero? ? [1.0, 1.0] : [ordinate_axis.origin, ordinate_distance]

        origin = scale_value_along_100_unit_axis(vertical_starting_point, ordinate_distance_to_draw)

        (origin += ordinate_axis.origin) if ordinate_distance.zero?

        new_axis_view(ordinate_axis.name, ordinate_axis.number_labels, origin)
      end

      def calculate_new_curves
        original_view.curves.map do |expression_graph_view|
          path = scale_path_to_target_sized_square(expression_graph_view.path)
          new_expression_graph_view(expression_graph_view.text, path)
        end
      end

      def scale_path_to_target_sized_square(expression_path,
                                            abscissa_axis_distance = abscissa_distance,
                                            ordinate_axis_distance = ordinate_distance)
        expression_path_scaler
          .scale_to_target_sized_square(expression_path, abscissa_axis_distance, ordinate_axis_distance)
      end

      def scale_value_along_100_unit_axis(value, axis_distance)
        expression_path_scaler.scale_along_axis(value, axis_distance)
      end

      def abscissa_distance
        expression_graph_parameters[:abscissa_distance]
      end

      def ordinate_distance
        expression_graph_parameters[:ordinate_distance]
      end

      def new_view(*)
        View.new(*)
      end

      def new_graphing_view(*)
        Graphing::View.new(*)
      end

      def new_expression_graph_view(*)
        Graphing::ExpressionGraphView.new(*)
      end

      def new_axis_view(*)
        Graphing::AxisView.new(*)
      end

      def expression_path_scaler
        @expression_path_scaler ||=
          Graphing::ExpressionPathScaler.new(100, @numerical_analysis_item_factory)
      end

      def_delegators :original_view, :ordinate_axis, :expression_graph_parameters

      attr_reader :original_view
    end
  end
end
