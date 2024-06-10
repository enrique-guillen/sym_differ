# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the exponentiation expression can re-expressed for reduction purposes, after removing
    # the superfluous terms and putting it into canonical form.
    class ExponentiateExpressionReductionAnalyzer
      extend Forwardable

      def initialize(expression_factory, reduction_analysis_visitor)
        @expression_factory = expression_factory
        @reduction_analysis_visitor = reduction_analysis_visitor
      end

      def reduce_expression(expression)
        reduced_base = calculate_reduction_results(expression.base)
        reduced_power = calculate_reduction_results(expression.power)

        return create_constant_one if reduced_power.same_as?(create_constant_zero)
        return reduced_base if reduced_power.same_as?(create_constant_one)
        return create_constant_zero if reduced_base.same_as?(create_constant_zero) && positive_constant?(reduced_power)

        if evaluatable_exponentiation?(reduced_base, reduced_power)
          return evaluate_exponentiation_of_constants(reduced_base, reduced_power)
        end

        create_exponentiate_expression(reduced_base, reduced_power)
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

      def evaluatable_exponentiation?(base, power)
        all_constants?(base, power) && non_zero_constant?(base)
      end

      def all_constants?(*expressions)
        expressions.all? { |e| constant_expression?(e) }
      end

      def non_zero_constant?(expression)
        !expression.same_as?(create_constant_zero)
      end

      def positive_constant?(expression)
        constant_expression?(expression) && expression.value.positive?
      end

      def create_constant_zero
        create_constant_expression(0)
      end

      def create_constant_one
        create_constant_expression(1)
      end

      def evaluate_exponentiation_of_constants(base, power)
        create_constant_expression(base.value**power.value)
      end

      def_delegators :@expression_factory,
                     :create_constant_expression,
                     :create_exponentiate_expression,
                     :constant_expression?

      def calculate_reduction_results(expression)
        @reduction_analysis_visitor.reduce(expression)
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
