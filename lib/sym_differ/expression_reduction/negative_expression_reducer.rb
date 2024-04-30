# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the negation expression can re-expressed for reduction purposes, after removing the
    # superfluous terms and putting it into canonical form.
    class NegativeExpressionReducer
      def initialize(expression_factory, reducer)
        @expression_factory = expression_factory
        @reducer = reducer
      end

      def reduce(expression)
        negated_expression_reduction_results = @reducer.reduction_analysis(expression.negated_expression)
        value, subexpression = negated_expression_reduction_results[:sum_partition]

        reduced_expression_from_subexpression = create_reduced_expression_from_subexpression(value, subexpression)
        sum_partition = create_sum_partition(value, subexpression)
        factor_partition = create_factor_partition(expression)

        build_reduction_results(reduced_expression_from_subexpression, sum_partition, factor_partition)
      end

      private

      def create_reduced_expression_from_subexpression(value, subexpression)
        return build_integer_expression(value) if subexpression.nil? && value.zero?
        return build_negate_expression(build_integer_expression(value)) if subexpression.nil?
        return subexpression.negated_expression if negate_expression?(subexpression)

        build_negate_expression(subexpression)
      end

      def create_sum_partition(value, subexpression)
        return build_sum_partition(-value, nil) if subexpression.nil?
        return build_sum_partition(-value, subexpression.negated_expression) if negate_expression?(subexpression)

        build_sum_partition(-value, build_negate_expression(subexpression))
      end

      def create_factor_partition(expression)
        [-1, expression.negated_expression]
      end

      def build_integer_expression(total_value)
        return create_constant_expression(total_value) if total_value.positive? || total_value.zero?

        build_negate_expression(create_constant_expression(-total_value))
      end

      def create_constant_expression(value)
        @expression_factory.create_constant_expression(value)
      end

      def negate_expression?(expression)
        expression.is_a?(Expressions::NegateExpression)
      end

      def build_negate_expression(negated_expression)
        @expression_factory.create_negate_expression(negated_expression)
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
