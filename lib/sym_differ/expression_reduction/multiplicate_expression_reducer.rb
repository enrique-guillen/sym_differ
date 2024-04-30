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
        multiplicand_reduction_results = @reducer.reduction_analysis(expression.multiplicand)
        multiplier_reduction_results = @reducer.reduction_analysis(expression.multiplier)

        multiplicand_subexpression = multiplicand_reduction_results[:reduced_expression]
        multiplier_subexpression = multiplier_reduction_results[:reduced_expression]

        expression = create_reduced_expression(multiplicand_subexpression, multiplier_subexpression)
        sum_partition = create_sum_partition(expression, multiplicand_subexpression, multiplier_subexpression)

        build_reduction_results(expression, sum_partition)
      end

      private

      def create_reduced_expression(multiplicand_subexpression, multiplier_subexpression)
        if constant_zero?(multiplicand_subexpression) || constant_zero?(multiplier_subexpression)
          return create_constant_expression(0)
        end

        return multiplicand_subexpression if constant_one?(multiplier_subexpression)
        return multiplier_subexpression if constant_one?(multiplicand_subexpression)

        if constant_expression?(multiplicand_subexpression) && constant_expression?(multiplier_subexpression)
          return create_constant_expression(multiplicand_subexpression.value * multiplier_subexpression.value)
        end

        create_multiplicate_expression(multiplicand_subexpression, multiplier_subexpression)
      end

      def create_sum_partition(expression, multiplicand_subexpression, multiplier_subexpression)
        if constant_zero?(multiplicand_subexpression) || constant_zero?(multiplier_subexpression)
          return build_sum_partition(0, nil)
        end

        if constant_expression?(multiplicand_subexpression) && constant_expression?(multiplier_subexpression)
          return build_sum_partition(multiplicand_subexpression.value * multiplier_subexpression.value, nil)
        end

        build_sum_partition(0, expression)
      end

      def constant_zero?(expression)
        expression.is_a?(Expressions::ConstantExpression) && expression.value.zero?
      end

      def constant_one?(expression)
        expression.is_a?(Expressions::ConstantExpression) && expression.value == 1
      end

      def constant_expression?(expression)
        expression.is_a?(Expressions::ConstantExpression)
      end

      def create_constant_expression(value)
        @expression_factory.create_constant_expression(value)
      end

      def create_multiplicate_expression(multiplicand, multiplier)
        @expression_factory.create_multiplicate_expression(multiplicand, multiplier)
      end

      def build_reduction_results(reduced_expression, sum_partition)
        { reduced_expression:, sum_partition: }
      end

      def build_sum_partition(constant, subexpression)
        [constant, subexpression]
      end
    end
  end
end
