# frozen_string_literal: true

module SymDiffer
  # Coordinates representing the value (ordinate) of the given expression at the specified parameter (abscissa).
  class EvaluationPoint
    def initialize(abscissa, ordinate)
      @abscissa = abscissa
      @ordinate = ordinate
    end

    attr_reader :abscissa, :ordinate

    def same_as?(other_evaluation_point)
      abscissa == other_evaluation_point.abscissa && ordinate == other_evaluation_point.ordinate
    end
  end
end
