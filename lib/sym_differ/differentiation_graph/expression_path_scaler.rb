# frozen_string_literal: true

require "sym_differ/differentiation_graph/evaluation_point"

module SymDiffer
  module DifferentiationGraph
    # Resizes the provided expression path's points so that the maximum value is scaled to the target size.
    class ExpressionPathScaler
      def initialize(target_size)
        @target_size = target_size.to_f
      end

      def scale_to_target_sized_square(expression_path, abscissa_axis_distance, ordinate_axis_distance)
        expression_path.map do |expression_point|
          new_abscissa = scale(expression_point.abscissa, @target_size / abscissa_axis_distance.to_f)
          new_ordinate = scale(expression_point.ordinate, @target_size / ordinate_axis_distance.to_f)

          build_evaluation_point(new_abscissa, new_ordinate)
        end
      end

      private

      def scale(value, factor)
        value * factor
      end

      def build_evaluation_point(abscissa, ordinate)
        EvaluationPoint.new(abscissa, ordinate)
      end
    end
  end
end
