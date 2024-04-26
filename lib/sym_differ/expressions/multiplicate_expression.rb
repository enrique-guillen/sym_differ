# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents an expression representing the multiplication of the two sub expressions.
    class MultiplicateExpression
      def initialize(multiplicand, multiplier)
        @multiplicand = multiplicand
        @multiplier = multiplier
      end

      attr_reader :multiplicand, :multiplier
    end
  end
end
