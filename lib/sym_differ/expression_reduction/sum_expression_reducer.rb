# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the sum expression can re-expressed for reduction purposes, after removing the
    # superfluous terms and putting it into canonical form.
    class SumExpressionReducer
      def initialize(expression_factory, reducer)
        @reducer = reducer
        @expression_factory = expression_factory
      end

      def reduce(expression)
        reduce_expression_a_results = reduce_expression(expression.expression_a)
        reduce_expression_b_results = reduce_expression(expression.expression_b)

        subvalue_a, subexp_a = expression_reduction_sum_partition(reduce_expression_a_results)
        subvalue_b, subexp_b = expression_reduction_sum_partition(reduce_expression_b_results)

        total_value = subvalue_a + subvalue_b
        sum_partition = create_sum_partition(total_value, subexp_a, subexp_b)
        reduced_expression = remove_null_terms_of_reduced_expression(sum_partition, total_value, subexp_a, subexp_b)
        factor_partition = [1, reduced_expression]

        build_reduction_results(reduced_expression, sum_partition, factor_partition)
      end

      private

      def remove_null_terms_of_reduced_expression(sum_partition, total_value, subexp_a, subexp_b)
        if sum_partition_subexpression(sum_partition).nil? && sum_partition_constant(sum_partition).zero?
          create_constant_expression(0)
        elsif sum_partition_constant(sum_partition).zero?
          sum_partition_subexpression(sum_partition)
        else
          create_reduced_expression_from_subexpressions(total_value, subexp_a, subexp_b)
        end
      end

      def create_reduced_expression_from_subexpressions(total_value, subexp_a, subexp_b)
        return create_constant_expression(total_value) if subexp_a.nil? && subexp_b.nil?
        return create_sum_expression(subexp_b, create_constant_expression(total_value)) if subexp_a.nil?
        return create_sum_expression(subexp_a, create_constant_expression(total_value)) if subexp_b.nil?

        create_sum_expression(
          create_sum_expression(subexp_a, subexp_b),
          create_constant_expression(total_value)
        )
      end

      def create_sum_partition(total_value, subexp_a, subexp_b)
        return build_sum_partition(total_value, nil) if subexp_a.nil? && subexp_b.nil?
        return build_sum_partition(total_value, subexp_b) if subexp_a.nil?
        return build_sum_partition(total_value, subexp_a) if subexp_b.nil?

        build_sum_partition(total_value, create_sum_expression(subexp_a, subexp_b))
      end

      def reduce_expression(expression)
        @reducer.reduction_analysis(expression)
      end

      def create_constant_expression(value)
        @expression_factory.create_constant_expression(value)
      end

      def create_sum_expression(expression_a, expression_b)
        @expression_factory.create_sum_expression(expression_a, expression_b)
      end

      def expression_reduction_sum_partition(reduction_results)
        reduction_results[:sum_partition]
      end

      def sum_partition_constant(sum_partition)
        sum_partition[0]
      end

      def sum_partition_subexpression(sum_partition)
        sum_partition[1]
      end

      def build_reduction_results(reduced_expression, sum_partition, factor_partition)
        { reduced_expression:, sum_partition:, factor_partition: }
      end

      def build_sum_partition(constant, subexpression)
        [constant, subexpression]
      end
    end
  end
end
