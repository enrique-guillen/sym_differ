# frozen_string_literal: true

require "sym_differ/sum_expression"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Builds a SumExpression out of the provided arguments.
    class BuildSumExpressionCommand
      def execute(arguments)
        expression_a, expression_b = arguments
        build_sum_expression(expression_a, expression_b)
      end

      private

      def build_sum_expression(expression_a, expression_b)
        SumExpression.new(expression_a, expression_b)
      end
    end
  end
end
