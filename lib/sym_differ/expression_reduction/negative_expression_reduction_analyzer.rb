# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the multiplicate expression can re-expressed for reduction purposes, after removing
    # the superfluous terms and putting it into canonical form.
    class NegativeExpressionReductionAnalyzer
      def initialize(expression_factory, sum_partitioner, factor_partitioner)
        @expression_factory = expression_factory
        @sum_partitioner = sum_partitioner
        @factor_partitioner = factor_partitioner
      end

      def reduce_expression(expression)
        negated_expression_reduction_results = @factor_partitioner.partition(expression.negated_expression)
        total_factor, subexpression = negated_expression_reduction_results

        create_reduced_expression_from_subexpression(total_factor, subexpression)
      end

      def make_sum_partition(expression)
        negated_expression_reduction_results = @sum_partitioner.partition(expression.negated_expression)
        total_value, sum_subexpression = negated_expression_reduction_results

        create_sum_partition(total_value, sum_subexpression)
      end

      def make_factor_partition(expression)
        negated_expression_reduction_results = @factor_partitioner.partition(expression.negated_expression)
        total_factor, subexpression = negated_expression_reduction_results

        create_factor_partition(total_factor, subexpression)
      end

      private

      def create_reduced_expression_from_subexpression(factor, expression)
        return create_negate_expression(create_constant_expression(factor)) if expression.nil? && factor.positive?

        return create_constant_expression(-factor) if expression.nil?
        return create_negate_expression(expression) if factor == 1
        return expression if factor == -1
        return create_multiplicate_expression(create_constant_expression(-factor), expression) if factor.negative?

        create_negate_expression(
          create_multiplicate_expression(create_constant_expression(factor), expression)
        )
      end

      def create_sum_partition(total_value, expression)
        return build_sum_partition(-total_value, nil) if expression.nil?
        return build_sum_partition(-total_value, expression.negated_expression) if negate_expression?(expression)

        build_sum_partition(-total_value, create_negate_expression(expression))
      end

      def create_factor_partition(total_factor, expression)
        build_factor_partition(-total_factor, expression)
      end

      def negate_expression?(expression)
        expression.is_a?(Expressions::NegateExpression)
      end

      def create_constant_expression(total_factor)
        @expression_factory.create_constant_expression(total_factor)
      end

      def create_negate_expression(negated_expression)
        @expression_factory.create_negate_expression(negated_expression)
      end

      def create_multiplicate_expression(multiplicand, multiplier)
        @expression_factory.create_multiplicate_expression(multiplicand, multiplier)
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
