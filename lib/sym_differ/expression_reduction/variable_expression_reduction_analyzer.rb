# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the variable expression can re-expressed for reduction purposes, after removing the
    # superfluous terms and putting it into canonical form.
    class VariableExpressionReductionAnalyzer
      def reduce_expression(expression)
        expression
      end

      def make_sum_partition(expression)
        build_sum_partition(0, expression)
      end

      def make_factor_partition(expression)
        build_factor_partition(1, expression)
      end

      private

      def build_reduction_results(reduced_expression, sum_partition, factor_partition)
        { reduced_expression:, sum_partition:, factor_partition: }
      end

      def build_sum_partition(constant, subexpression)
        [constant, subexpression]
      end

      def build_factor_partition(constant, subexpression)
        [constant, subexpression]
      end
    end
  end
end
