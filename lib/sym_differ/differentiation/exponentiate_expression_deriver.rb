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

        if expression.base.same_as?(create_euler_number_expression)
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

      def derivative_of_expression_raised_to_constant_power(expression)
        base = expression.base
        power = expression.power

        create_multiplicate_expression(
          create_multiplicate_expression(
            power,
            create_exponentiate_expression(base, create_subtract_expression(power, create_constant_expression(1)))
          ),
          derive_expression(base)
        )
      end

      def derivative_of_euler_number_raised_to_expression_power(expression)
        create_multiplicate_expression(
          expression,
          derive_expression(expression.power)
        )
      end

      def derivative_of_arbitrary_exponentiation(expression)
        derive_expression(
          create_exponentiate_expression(
            create_euler_number_expression,
            create_multiplicate_expression(
              expression.power, create_natural_logarithm_expression(expression.base)
            )
          )
        )
      end

      def derive_expression(expression)
        @differentiation_visitor.derive(expression)
      end

      def walk_variable_expressions(expression, &)
        walk_expression(expression, yield_at: %i[variables], &)
      end

      def_delegators :@expression_factory,
                     :create_multiplicate_expression,
                     :create_exponentiate_expression,
                     :create_subtract_expression,
                     :create_constant_expression,
                     :create_euler_number_expression,
                     :create_natural_logarithm_expression

      def_delegator :@expression_walker, :walk, :walk_expression
    end
  end
end
