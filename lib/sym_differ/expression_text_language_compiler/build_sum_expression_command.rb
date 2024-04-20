# frozen_string_literal: true

require "sym_differ/sum_expression"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Builds a SumExpression out of the provided arguments.
    class BuildSumExpressionCommand
      def initialize(expression_factory)
        @expression_factory = expression_factory
      end

      def execute(arguments)
        expression_a, expression_b = arguments
        build_sum_expression(expression_a, expression_b)
      end

      private

      def build_sum_expression(expression_a, expression_b)
        @expression_factory.create_sum_expression(expression_a, expression_b)
      end
    end
  end
end
