# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the variable expression can re-expressed for reduction purposes, after removing the
    # superfluous terms and putting it into canonical form.
    class VariableExpressionReducer
      def reduce(expression)
        build_reduction_results(
          expression,
          build_sum_partition(0, expression),
          build_factor_partition(1, expression)
        )
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
