# frozen_string_literal: true

module SymDiffer
  module NumericalAnalysis
    # Represents a range of "steps" -- coordinates where the value of a function was sampled. Can be used to specify
    # the range over which a function should be sampled/evaluated.
    class StepRange
      def initialize(range = (0..0))
        @range = range
      end

      def first_element
        @range.first
      end

      def last_element
        @range.last
      end

      def minimum
        @range.min
      end

      def maximum
        @range.max
      end
    end
  end
end
