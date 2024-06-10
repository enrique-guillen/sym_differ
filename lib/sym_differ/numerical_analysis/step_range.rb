# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module NumericalAnalysis
    # Represents a range of "steps" -- coordinates where the value of a function was sampled. Can be used to specify
    # the range over which a function should be sampled/evaluated.
    class StepRange
      extend Forwardable

      def initialize(range = (0..0))
        @range = range
      end

      def_delegator :@range, :first, :first_element
      def_delegator :@range, :last, :last_element
      def_delegator :@range, :min, :minimum
      def_delegator :@range, :max, :maximum
    end
  end
end
