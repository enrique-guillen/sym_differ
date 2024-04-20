# frozen_string_literal: true

require "sym_differ/subtract_expression"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Builds a SubtractExpression out of the provided arguments.
    class BuildSubtractExpressionCommand
      def execute(arguments)
        if arguments.size == 1
          negated_expression = arguments.first
          build_negate_expression(negated_expression)
        else
          minuend, subtrahend = arguments
          build_subtract_expression(minuend, subtrahend)
        end
      end

      private

      def build_subtract_expression(minuend, subtrahend)
        SubtractExpression.new(minuend, subtrahend)
      end

      def build_negate_expression(negated_expression)
        NegateExpression.new(negated_expression)
      end
    end
  end
end
