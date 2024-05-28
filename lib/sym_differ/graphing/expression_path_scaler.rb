# frozen_string_literal: true

require "sym_differ/numerical_analysis/evaluation_point"

module SymDiffer
  module Graphing
    # Resizes the provided expression path's points so that all points can fit in a square of size = @target_size
    # and exposes the underlying scaling operation that's performed on each value as a separate method.
    class ExpressionPathScaler
      def initialize(target_size, numerical_analysis_item_factory)
        @target_size = target_size.to_f
        @numerical_analysis_item_factory = numerical_analysis_item_factory
      end

      def scale_to_target_sized_square(expression_path, abscissa_axis_distance, ordinate_axis_distance)
        scaled_evaluation_points =
          scale_evaluation_points(expression_path, abscissa_axis_distance, ordinate_axis_distance)

        @numerical_analysis_item_factory.create_expression_path(scaled_evaluation_points)
      end

      def scale_along_axis(*)
        _scale_along_axis(*)
      end

      private

      def scale_evaluation_points(expression_path, abscissa_axis_distance, ordinate_axis_distance)
        expression_path.each.map do |expression_point|
          scale_evaluation_point(expression_point, abscissa_axis_distance, ordinate_axis_distance)
        end
      end

      def scale_evaluation_point(expression_point, abscissa_axis_distance, ordinate_axis_distance)
        new_abscissa = scale_along_axis(expression_point.abscissa, abscissa_axis_distance)
        new_ordinate = scale_along_axis(expression_point.ordinate, ordinate_axis_distance)

        build_evaluation_point(new_abscissa, new_ordinate)
      end

      def _scale_along_axis(value, axis_distance)
        (axis_distance = @target_size) if axis_distance.zero?

        scale(value, @target_size / axis_distance.to_f)
      end

      def scale(value, factor)
        value * factor
      end

      def build_evaluation_point(abscissa, ordinate)
        NumericalAnalysis::EvaluationPoint.new(abscissa, ordinate)
      end
    end
  end
end
