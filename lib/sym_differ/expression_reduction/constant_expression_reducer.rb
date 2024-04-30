# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the constant expression can re-expressed for reduction purposes, after removing the
    # superfluous terms and putting it into canonical form.
    class ConstantExpressionReducer
      def reduce(expression)
        build_reduction_results(
          expression,
          build_sum_partition(expression.value, nil),
          build_factor_partition(expression.value, nil)
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
