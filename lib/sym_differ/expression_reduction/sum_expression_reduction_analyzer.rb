# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the sum expression can re-expressed for reduction purposes, after removing the
    # superfluous terms and putting it into canonical form.
    class SumExpressionReductionAnalyzer
      def initialize(expression_factory, sum_partitioner, factor_partitioner)
        @expression_factory = expression_factory
        @sum_partitioner = sum_partitioner
        @factor_partitioner = factor_partitioner
      end

      def reduce_expression(expression)
        subvalue_a, subexp_a = expression_reduction_sum_partition(expression.expression_a)
        subvalue_b, subexp_b = expression_reduction_sum_partition(expression.expression_b)

        total_value = subvalue_a + subvalue_b
        nested_expression = create_reduced_expression_from_sum_subexpressions(subexp_a, subexp_b)

        remove_null_terms_of_reduced_expression(total_value, nested_expression)
      end

      def make_factor_partition(expression)
        subvalue_a, subexp_a = expression_reduction_sum_partition(expression.expression_a)
        subvalue_b, subexp_b = expression_reduction_sum_partition(expression.expression_b)

        total_value = subvalue_a + subvalue_b
        nested_expression = create_reduced_expression_from_sum_subexpressions(subexp_a, subexp_b)
        reduced_expression = remove_null_terms_of_reduced_expression(total_value, nested_expression)

        create_factors_partition(reduced_expression)
      end

      def make_sum_partition(expression)
        subvalue_a, subexp_a = expression_reduction_sum_partition(expression.expression_a)
        subvalue_b, subexp_b = expression_reduction_sum_partition(expression.expression_b)

        total_value = subvalue_a + subvalue_b
        nested_expression = create_reduced_expression_from_sum_subexpressions(subexp_a, subexp_b)

        create_sum_partition(total_value, nested_expression)
      end

      private

      def create_reduced_expression_from_sum_subexpressions(subexp_a, subexp_b)
        return if subexp_a.nil? && subexp_b.nil?
        return subexp_b if subexp_a.nil?
        return subexp_a if subexp_b.nil?

        create_sum_expression(subexp_a, subexp_b)
      end

      def remove_null_terms_of_reduced_expression(total_value, nested_expression)
        return create_constant_expression(total_value) if nested_expression.nil?
        return nested_expression if total_value.zero?

        create_sum_expression(nested_expression, create_constant_expression(total_value))
      end

      def create_sum_partition(total_value, nested_expression)
        build_sum_partition(total_value, nested_expression)
      end

      def create_factors_partition(reduced_expression)
        return build_factors_partition(1, reduced_expression) if reduced_expression.is_a?(Expressions::SumExpression)

        @factor_partitioner.partition(reduced_expression)
      end

      def create_constant_expression(value)
        @expression_factory.create_constant_expression(value)
      end

      def create_sum_expression(expression_a, expression_b)
        @expression_factory.create_sum_expression(expression_a, expression_b)
      end

      def expression_reduction_sum_partition(expression)
        @sum_partitioner.partition(expression)
      end

      def build_reduction_results(reduced_expression, sum_partition, factor_partition)
        { reduced_expression:, sum_partition:, factor_partition: }
      end

      def build_sum_partition(constant, subexpression)
        [constant, subexpression]
      end

      def build_factors_partition(constant, subexpression)
        [constant, subexpression]
      end
    end
  end
end
