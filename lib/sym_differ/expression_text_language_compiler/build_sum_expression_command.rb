# frozen_string_literal: true

require "sym_differ/sum_expression"
require "sym_differ/positive_expression"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Builds a SumExpression out of the provided arguments.
    class BuildSumExpressionCommand
      def initialize(expression_factory)
        @expression_factory = expression_factory
      end

      def execute(arguments)
        if arguments.size < 2
          summand = arguments[0]
          build_positive_expression(summand)
        else
          expression_a, expression_b = arguments
          build_sum_expression(expression_a, expression_b)
        end
      end

      private

      def build_sum_expression(expression_a, expression_b)
        @expression_factory.create_sum_expression(expression_a, expression_b)
      end

      def build_positive_expression(summand)
        @expression_factory.create_positive_expression(summand)
      end
    end
  end
end
