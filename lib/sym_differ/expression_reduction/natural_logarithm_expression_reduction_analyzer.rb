# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the natural-logarithm expression can re-expressed for reduction purposes, after
    # removing the superfluous terms and putting it into canonical form.
    class NaturalLogarithmExpressionReductionAnalyzer
      extend Forwardable

      def initialize(expression_factory, expression_reducer)
        @expression_factory = expression_factory
        @expression_reducer = expression_reducer
      end

      def reduce_expression(expression)
        reduced_power_expression = reduce_subexpression(expression.power)

        return create_constant_zero if same_as_constant_one?(reduced_power_expression)
        return create_constant_one if same_as_euler_number_expression?(reduced_power_expression)

        if multiplicate_expression?(reduced_power_expression)
          return reduced_logarithms_sum_of_multiplication(reduced_power_expression)
        end

        if exponentiate_expression?(reduced_power_expression)
          return reduced_scaled_logarithm_of_exponentiation(reduced_power_expression)
        end

        create_natural_logarithm_expression(reduced_power_expression)
      end

      def make_factor_partition(expression)
        reduced_expression = reduce_expression(expression)

        if constant_expression?(reduced_expression)
          build_factor_partition(reduced_expression.value, nil)
        else
          build_factor_partition(1, reduced_expression)
        end
      end

      private

      def same_as_constant_one?(expression)
        expression.same_as?(create_constant_one)
      end

      def same_as_euler_number_expression?(expression)
        expression.same_as?(create_euler_number_expression)
      end

      def create_constant_one
        create_constant_expression(1)
      end

      def create_constant_zero
        create_constant_expression(0)
      end

      def reduced_logarithms_sum_of_multiplication(expression)
        reduce_subexpression(
          create_sum_expression(
            create_natural_logarithm_expression(expression.multiplicand),
            create_natural_logarithm_expression(expression.multiplier)
          )
        )
      end

      def reduced_scaled_logarithm_of_exponentiation(expression)
        reduce_subexpression(
          create_multiplicate_expression(
            expression.power,
            create_natural_logarithm_expression(expression.base)
          )
        )
      end

      def_delegator :@expression_reducer, :reduce, :reduce_subexpression

      def_delegators :@expression_factory,
                     :create_constant_expression,
                     :create_sum_expression,
                     :create_multiplicate_expression,
                     :create_euler_number_expression,
                     :create_natural_logarithm_expression,
                     :constant_expression?,
                     :multiplicate_expression?,
                     :exponentiate_expression?

      def build_factor_partition(constant, subexpression)
        [constant, subexpression]
      end
    end
  end
end
