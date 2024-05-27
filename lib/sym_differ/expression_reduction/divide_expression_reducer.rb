# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the division expression can re-expressed for reduction purposes, after removing the
    # superfluous terms and putting it into canonical form.
    class DivideExpressionReducer
      def initialize(expression_factory, reducer)
        @expression_factory = expression_factory
        @reducer = reducer
      end

      def reduce(expression)
        numerator_reduction_results = calculate_reduction_results(expression.numerator)
        denominator_reduction_results = calculate_reduction_results(expression.denominator)

        reduced_expression =
          create_divide_expression(
            access_reduced_expression(numerator_reduction_results),
            access_reduced_expression(denominator_reduction_results)
          )

        sum_partition = build_sum_partition(0, reduced_expression)
        factor_partition = build_factor_partition(1, reduced_expression)

        build_reduction_results(reduced_expression, sum_partition, factor_partition)
      end

      private

      def access_reduced_expression(reduction_results)
        reduction_results[:reduced_expression]
      end

      def build_reduction_results(reduced_expression, sum_partition, factor_partition)
        { reduced_expression:, sum_partition:, factor_partition: }
      end

      def build_sum_partition(constant, subexpression)
        [constant, subexpression]
      end

      def build_factor_partition(constant, subexpression)
        [constant, subexpression]
      end

      def create_divide_expression(*)
        @expression_factory.create_divide_expression(*)
      end

      def calculate_reduction_results(expression)
        @reducer.reduction_analysis(expression)
      end
    end
  end
end
