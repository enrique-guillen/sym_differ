# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the subtraction expression can re-expressed for reduction purposes, after removing
    # the superfluous terms and putting it into canonical form.
    class SubtractExpressionReductionAnalyzer
      def initialize(expression_factory, sum_partitioner, factor_partitioner)
        @expression_factory = expression_factory
        @sum_partitioner = sum_partitioner
        @factor_partitioner = factor_partitioner
      end

      def reduce_expression(expression)
        subvalue_a, subexp_a = expression_reduction_sum_partition(expression.minuend)
        subvalue_b, subexp_b = expression_reduction_sum_partition(expression.subtrahend)

        total_value = subvalue_a - subvalue_b

        create_reduced_expression_from_subexpressions(total_value, subexp_a, subexp_b)
      end

      def make_factor_partition(expression)
        subvalue_a, subexp_a = expression_reduction_sum_partition(expression.minuend)
        subvalue_b, subexp_b = expression_reduction_sum_partition(expression.subtrahend)

        total_value = subvalue_a - subvalue_b

        reduced_expression = create_reduced_expression_from_subexpressions(total_value, subexp_a, subexp_b)

        create_factor_partition(reduced_expression)
      end

      def make_sum_partition(expression)
        subvalue_a, subexp_a = expression_reduction_sum_partition(expression.minuend)
        subvalue_b, subexp_b = expression_reduction_sum_partition(expression.subtrahend)

        total_value = subvalue_a - subvalue_b

        create_sum_partition(total_value, subexp_a, subexp_b)
      end

      private

      def create_reduced_expression_from_subexpressions(total_value, minuend, subtrahend)
        nested_expression = create_reduced_expression_from_subtraction_expression(minuend, subtrahend)

        return build_integer_expression(total_value) if nested_expression.nil?
        return nested_expression if total_value.zero?

        if total_value.negative?
          return build_subtract_expression(nested_expression, build_integer_expression(-total_value))
        end

        build_sum_expression(nested_expression, build_constant_expression(total_value))
      end

      def create_sum_partition(total_value, subexp_a, subexp_b)
        nested_expression = create_reduced_expression_from_subtraction_expression(subexp_a, subexp_b)
        build_sum_partition(total_value, nested_expression)
      end

      def create_factor_partition(reduced_expression)
        if reduced_expression.is_a?(Expressions::SubtractExpression)
          return build_factors_partition(1, reduced_expression)
        end

        @factor_partitioner.partition(reduced_expression)
      end

      def create_reduced_expression_from_subtraction_expression(minuend, subtrahend)
        reduced_expression_from_nil_minuend_and_negative_subtrahend(minuend, subtrahend) ||
          reduced_expression_from_nil_minuend(minuend, subtrahend) ||
          reduced_expression_from_nil_subtrahend(minuend, subtrahend) ||
          reduced_expression_from_negative_subtrahend(minuend, subtrahend) ||
          reduced_expression_from_minuend_and_subtrahend(minuend, subtrahend)
      end

      def reduced_expression_from_nil_minuend_and_negative_subtrahend(minuend, subtrahend)
        subtrahend.negated_expression if minuend.nil? && negate_expression?(subtrahend)
      end

      def reduced_expression_from_nil_minuend(minuend, subtrahend)
        build_negate_expression(subtrahend) if minuend.nil? && !subtrahend.nil?
      end

      def reduced_expression_from_nil_subtrahend(minuend, subtrahend)
        minuend if subtrahend.nil?
      end

      def reduced_expression_from_negative_subtrahend(minuend, subtrahend)
        build_sum_expression(minuend, subtrahend.negated_expression) if negate_expression?(subtrahend)
      end

      def reduced_expression_from_minuend_and_subtrahend(minuend, subtrahend)
        build_subtract_expression(minuend, subtrahend) if minuend && subtrahend
      end

      def build_integer_expression(total_value)
        return build_constant_expression(total_value) if total_value.positive? || total_value.zero?

        build_negate_expression(build_constant_expression(-total_value))
      end

      def negate_expression?(expression)
        expression.is_a?(Expressions::NegateExpression)
      end

      def build_constant_expression(value)
        @expression_factory.create_constant_expression(value)
      end

      def build_sum_expression(expression_a, expression_b)
        @expression_factory.create_sum_expression(expression_a, expression_b)
      end

      def build_negate_expression(negated_expression)
        @expression_factory.create_negate_expression(negated_expression)
      end

      def build_subtract_expression(minuend, subtrahend)
        @expression_factory.create_subtract_expression(minuend, subtrahend)
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
