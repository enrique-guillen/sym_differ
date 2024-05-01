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

        nested_expression = create_reduced_expression_from_sum_subexpressions(subexp_a, subexp_b)

        reduced_expression = remove_null_terms_of_reduced_expression(total_value, nested_expression)
        sum_partition = create_sum_partition(total_value, nested_expression)
        factor_partition = create_factors_partition(reduced_expression)

        build_reduction_results(reduced_expression, sum_partition, factor_partition)
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

        @reducer.reduction_analysis(reduced_expression)[:factor_partition]
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
