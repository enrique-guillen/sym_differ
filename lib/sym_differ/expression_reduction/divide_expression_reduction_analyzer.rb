# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the division expression can re-expressed for reduction purposes, after removing the
    # superfluous terms and putting it into canonical form.
    class DivideExpressionReductionAnalyzer
      def initialize(expression_factory, reduction_analysis_visitor)
        @expression_factory = expression_factory
        @reduction_analysis_visitor = reduction_analysis_visitor
      end

      def reduce_expression(expression)
        numerator_reduction_results = calculate_reduction_results(expression.numerator)
        denominator_reduction_results = calculate_reduction_results(expression.denominator)

        create_divide_expression(
          numerator_reduction_results,
          denominator_reduction_results
        )
      end

      def make_sum_partition(expression)
        reduced_expression = reduce_expression(expression)

        build_sum_partition(0, reduced_expression)
      end

      def make_factor_partition(expression)
        reduced_expression = reduce_expression(expression)

        build_factor_partition(1, reduced_expression)
      end

      private

      def calculate_reduction_results(expression)
        expression.accept(@reduction_analysis_visitor)
      end

      def create_divide_expression(*)
        @expression_factory.create_divide_expression(*)
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
