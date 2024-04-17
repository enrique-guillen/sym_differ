# frozen_string_literal: true

require "sym_differ/subtract_expression"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Builds a SubtractExpression out of the provided arguments.
    class BuildSubtractExpressionCommand
      def execute(arguments)
        minuend, subtrahend = arguments
        build_subtract_expression(minuend, subtrahend)
      end

      private

      def build_subtract_expression(minuend, subtrahend)
        SubtractExpression.new(minuend, subtrahend)
      end
    end
  end
end
