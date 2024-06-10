# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the division expression can re-expressed for reduction purposes, after removing the
    # superfluous terms and putting it into canonical form.
    class DivideExpressionReductionAnalyzer
      extend Forwardable

      def initialize(expression_factory, reduction_analysis_visitor)
        @expression_factory = expression_factory
        @reduction_analysis_visitor = reduction_analysis_visitor
      end

      def reduce_expression(expression)
        reduced_numerator = calculate_reduction_results(expression.numerator)
        reduced_denominator = calculate_reduction_results(expression.denominator)

        return reduced_numerator if reduced_denominator.same_as?(create_constant_one)

        return create_constant_zero if reduced_numerator.same_as?(create_constant_zero) &&
                                       !reduced_denominator.same_as?(create_constant_zero)

        create_divide_expression(reduced_numerator, reduced_denominator)
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

      def_delegators :@expression_factory,
                     :create_constant_expression,
                     :create_divide_expression

      def calculate_reduction_results(expression)
        expression.accept(@reduction_analysis_visitor)
      end

      def create_constant_zero
        create_constant_expression(0)
      end

      def create_constant_one
        create_constant_expression(1)
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
