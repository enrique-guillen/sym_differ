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
        @curve_stylings = curve_stylings

        abscissa_axis = generate_abscissa_axis_view
        ordinate_axis = generate_ordinate_axis_view
        curves = calculate_new_curves

        graphing_view = new_graphing_view(abscissa_axis, ordinate_axis, curves)

        new_view(false, abscissa_axis, ordinate_axis, curves)
      end

      private

      def generate_abscissa_axis_view
        origin = scale_abscissa_origin

        number_labels = abscissa_axis.number_labels.map { |l| format_axis_number_label(l) }

        new_axis_view(abscissa_axis.name, number_labels, origin)
      end

      def generate_ordinate_axis_view
        origin = scale_ordinate_origin

        number_labels = ordinate_axis.number_labels.map { |l| format_axis_number_label(l) }

        new_axis_view(ordinate_axis.name, number_labels, origin)
      end

      def calculate_new_curves
        original_view.curves.each_with_index.map do |expression_graph_view, index|
          path = scale_path_to_target_sized_square(expression_graph_view.path)
          new_expression_graph_view(expression_graph_view.text, path, access_style_for_curve(index))
        end
      end

      def scale_abscissa_origin
        -scale_value_along_100_unit_axis(abscissa_axis.origin, abscissa_distance)
      end

      def scale_ordinate_origin
        vertical_starting_point, ordinate_distance_to_draw =
          ordinate_distance.zero? ? [1.0, 1.0] : [ordinate_axis.origin, ordinate_distance]

        origin = scale_value_along_100_unit_axis(vertical_starting_point, ordinate_distance_to_draw)

        (origin += ordinate_axis.origin) if ordinate_distance.zero?

        origin
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

      def format_axis_number_label(label)
        rounded_label = label.round(3)

        return rounded_label if rounded_label.to_s.size <= 7

        format("%.1e", rounded_label)
      end

      def abscissa_distance
        expression_graph_parameters[:abscissa_distance]
      end

      def ordinate_distance
        expression_graph_parameters[:ordinate_distance]
      end

      def access_style_for_curve(index)
        curve_stylings[index]
      end

      def new_view(*)
        SvgGraphing::View.new(*)
      end

      def new_graphing_view(*)
        Graphing::View.new(*)
      end

      def new_expression_graph_view(*)
        SvgGraphing::ExpressionGraphView.new(*)
      end

      def new_axis_view(*)
        SvgGraphing::AxisView.new(*)
      end

      def expression_path_scaler
        @expression_path_scaler ||=
          Graphing::ExpressionPathScaler.new(100, @numerical_analysis_item_factory)
      end

      def_delegators :original_view, :abscissa_axis, :ordinate_axis, :expression_graph_parameters

      attr_reader :original_view, :curve_stylings
    end
  end
end
