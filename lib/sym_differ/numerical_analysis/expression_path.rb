# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module NumericalAnalysis
    # A list of coordinates where the value of a function was sampled or where the value of the function has been
    # determined to be undefined.
    class ExpressionPath
      extend Forwardable

      def initialize(evaluation_points)
        @evaluation_points = evaluation_points
      end

      attr_reader :evaluation_points

      def_delegator :@evaluation_points, :each

      def add_evaluation_point(point)
        ExpressionPath.new(@evaluation_points + [point])
      end

      def add_evaluation_points(points)
        ExpressionPath.new(@evaluation_points + points)
      end

      def max_abscissa_value
        @evaluation_points.map(&:abscissa).max
      end

      def min_abscissa_value
        @evaluation_points.map(&:abscissa).min
      end

      def max_ordinate_value
        @evaluation_points.map(&:ordinate).reject { |o| o == :undefined }.max
      end

      def min_ordinate_value
        @evaluation_points.map(&:ordinate).reject { |o| o == :undefined }.min
      end

      def first_evaluation_point
        @evaluation_points.first
      end

      def last_evaluation_point
        @evaluation_points.last
      end
    end
  end
end
