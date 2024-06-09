# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the multiplicate expression can re-expressed for reduction purposes, after removing
    # the superfluous terms and putting it into canonical form.
    class MultiplicateExpressionReductionAnalyzer
      def initialize(expression_factory, sum_partitioner, factor_partitioner)
        @expression_factory = expression_factory
        @sum_partitioner = sum_partitioner
        @factor_partitioner = factor_partitioner
      end

      def reduce_expression(expression)
        reduction_analysis = generate_reduction_analysis(expression)

        total_factor, multiplicand_subexpression, multiplier_subexpression =
          reduction_analysis.values_at(:total_factor, :multiplicand_subexpression, :multiplier_subexpression)

        create_reduced_expression(total_factor, multiplicand_subexpression, multiplier_subexpression)
      end

      def make_factor_partition(expression)
        reduction_analysis = generate_reduction_analysis(expression)

        total_factor, multiplicand_subexpression, multiplier_subexpression =
          reduction_analysis.values_at(:total_factor, :multiplicand_subexpression, :multiplier_subexpression)

        create_factor_partition(total_factor, multiplicand_subexpression, multiplier_subexpression)
      end

      def make_sum_partition(expression)
        reduced_expression = reduce_expression(expression)
        create_sum_partition(reduced_expression)
      end

      private

      def generate_reduction_analysis(expression)
        multiplicand_reduction_results = factor_partition(expression.multiplicand)
        multiplier_reduction_results = factor_partition(expression.multiplier)

        multiplicand_factor, multiplicand_subexpression = multiplicand_reduction_results
        multiplier_factor, multiplier_subexpression = multiplier_reduction_results

        total_factor = multiplicand_factor * multiplier_factor

        { total_factor:, multiplicand_subexpression:, multiplier_subexpression: }
      end

      def create_reduced_expression(total_factor, multiplicand_subexpression, multiplier_subexpression)
        return create_constant_expression(0) if total_factor.zero?

        nested_expression =
          create_reduced_expression_from_subexpressions(multiplicand_subexpression, multiplier_subexpression)

        return create_constant_expression(total_factor) if nested_expression.nil?
        return nested_expression if total_factor == 1

        create_multiplicate_expression(create_constant_expression(total_factor), nested_expression)
      end

      def create_sum_partition(expression)
        return build_sum_partition(0, expression) if expression.is_a?(Expressions::MultiplicateExpression)

        sum_partition(expression)
      end

      def create_factor_partition(total_factor, multiplicand_subexpression, multiplier_subexpression)
        nested_expression =
          if total_factor.negative? || total_factor.positive?
            create_reduced_expression_from_subexpressions(multiplicand_subexpression, multiplier_subexpression)
          end

        build_factor_partition(total_factor, nested_expression)
      end

      def create_reduced_expression_from_subexpressions(multiplicand_subexpression, multiplier_subexpression)
        return if multiplicand_subexpression.nil? && multiplier_subexpression.nil?
        return multiplicand_subexpression if multiplier_subexpression.nil?
        return multiplier_subexpression if multiplicand_subexpression.nil?

        create_multiplicate_expression(multiplicand_subexpression, multiplier_subexpression)
      end

      def factor_partition(expression)
        @factor_partitioner.partition(expression)
      end

      def sum_partition(expression)
        @sum_partitioner.partition(expression)
      end

      def create_constant_expression(value)
        @expression_factory.create_constant_expression(value)
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
