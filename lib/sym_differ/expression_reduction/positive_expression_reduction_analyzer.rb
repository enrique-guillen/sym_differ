# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Reduces the terms in the provided positive expression.
    class PositiveExpressionReductionAnalyzer
      def initialize(expression_reducer, sum_partitioner, factor_partitioner)
        @expression_reducer = expression_reducer
        @sum_partitioner = sum_partitioner
        @factor_partitioner = factor_partitioner
      end

      def reduce_expression(expression)
        @expression_reducer.reduce(expression.summand)
      end

      def make_sum_partition(expression)
        @sum_partitioner.partition(expression.summand)
      end

      def make_factor_partition(expression)
        @factor_partitioner.partition(expression.summand)
      end
    end
  end
end
