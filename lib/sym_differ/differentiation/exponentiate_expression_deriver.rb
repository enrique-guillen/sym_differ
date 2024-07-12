# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module Differentiation
    # Computes the expression that represents the derivative of a base expression raised to another power expression.
    class ExponentiateExpressionDeriver
      extend Forwardable

      def initialize(differentiation_visitor, expression_walker, expression_factory)
        @differentiation_visitor = differentiation_visitor
        @expression_walker = expression_walker
        @expression_factory = expression_factory
      end

      def derive(expression, variable)
        if expression_contains_no_variables?(expression.power, variable)
          return derivative_of_expression_raised_to_constant_power(expression)
        end

        if expression_is_euler_constant?(expression.base)
          return derivative_of_euler_number_raised_to_expression_power(expression)
        end

        derivative_of_arbitrary_exponentiation(expression)
      end

      private

      def expression_contains_no_variables?(expression, variable)
        was_no_variable_detected = true

        walk_variable_expressions(expression) do |subexpression|
          (break was_no_variable_detected = false) if subexpression.name == variable
        end

        was_no_variable_detected
      end

      def expression_is_euler_constant?(expression)
        expression.same_as?(create_euler_number_expression)
      end

      def derivative_of_expression_raised_to_constant_power(expression)
        power_minus_one =
          create_subtract_expression(expression.power, create_constant_expression(1))

        base_raised_to_power_minus_one =
          create_exponentiate_expression(expression.base, power_minus_one)

        derivative_function = create_multiplicate_expression(expression.power, base_raised_to_power_minus_one)
        parameter_expression = expression.base

        apply_chain_rule_to_expression(derivative_function, parameter_expression)
      end

      def derivative_of_euler_number_raised_to_expression_power(expression)
        derivative_function = expression
        parameter_expression = expression.power

        apply_chain_rule_to_expression(derivative_function, parameter_expression)
      end

      def derivative_of_arbitrary_exponentiation(expression)
        euler_number_expression = create_euler_number_expression

        power_times_logarithm_of_base =
          create_multiplicate_expression(expression.power, create_natural_logarithm_expression(expression.base))

        equivalent_exponentiation_expression =
          create_exponentiate_expression(euler_number_expression, power_times_logarithm_of_base)

        derive_expression(equivalent_exponentiation_expression)
      end

      def apply_chain_rule_to_expression(derivative_function, parameter_expression)
        create_multiplicate_expression(
          derivative_function,
          derive_expression(parameter_expression)
        )
      end

      def walk_variable_expressions(expression, &)
        walk_expression(expression, yield_at: %i[variables], &)
      end

      def_delegators :@expression_factory,
                     :create_constant_expression,
                     :create_subtract_expression,
                     :create_multiplicate_expression,
                     :create_exponentiate_expression,
                     :create_natural_logarithm_expression,
                     :create_euler_number_expression

      def_delegator :@differentiation_visitor, :derive, :derive_expression
      def_delegator :@expression_walker, :walk, :walk_expression
    end
  end
end
