# frozen_string_literal: true

require "sym_differ/expressions/constant_expression"

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the multiplicate expression can re-expressed for reduction purposes, after removing
    # the superfluous terms and putting it into canonical form.
    class MultiplicateExpressionReducer
      def initialize(expression_factory, reducer)
        @expression_factory = expression_factory
        @reducer = reducer
      end

      def reduce(expression)
        multiplicand_reduction_results = make_reduction_analysis(expression.multiplicand)
        multiplier_reduction_results = make_reduction_analysis(expression.multiplier)

        multiplicand_factor, multiplicand_subexpression = multiplicand_reduction_results[:factor_partition]
        multiplier_factor, multiplier_subexpression = multiplier_reduction_results[:factor_partition]
        total_factor = multiplicand_factor * multiplier_factor

        reduced_expression =
          create_reduced_expression(total_factor, multiplicand_subexpression, multiplier_subexpression)
        factor_partition = create_factor_partition(total_factor, multiplicand_subexpression, multiplier_subexpression)
        sum_partition = create_sum_partition(reduced_expression)

        build_reduction_results(reduced_expression, sum_partition, factor_partition)
      end

      private

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

        make_reduction_analysis(expression)[:sum_partition]
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

      def make_reduction_analysis(expression)
        @reducer.reduction_analysis(expression)
      end

      def create_constant_expression(value)
        @expression_factory.create_constant_expression(value)
      end

      def create_multiplicate_expression(multiplicand, multiplier)
        @expression_factory.create_multiplicate_expression(multiplicand, multiplier)
      end

      def build_reduction_results(reduced_expression, sum_partition, factor_partition)
        { reduced_expression:, sum_partition:, factor_partition: }
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
