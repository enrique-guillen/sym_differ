# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module Differentiation
    # Computes the expresion that represents the derivative of the division of two functions.
    class DivideExpressionDeriver
      extend Forwardable

      def initialize(expression_factory, deriver)
        @expression_factory = expression_factory
        @deriver = deriver
      end

      def derive(expression)
        numerator = create_numerator_of_derivative(expression)
        denominator = create_denominator_of_derivative(expression)

        create_divide_expression(numerator, denominator)
      end

      private

      def create_numerator_of_derivative(expression)
        create_subtract_expression(
          create_minuend_of_derivative(expression),
          create_subtrahend_of_derivative(expression)
        )
      end

      def create_denominator_of_derivative(expression)
        create_exponentiate_expression(
          expression.denominator,
          create_constant_expression(2)
        )
      end

      def create_minuend_of_derivative(expression)
        create_multiplicate_expression(derive_expression(expression.numerator), expression.denominator)
      end

      def create_subtrahend_of_derivative(expression)
        create_multiplicate_expression(expression.numerator, derive_expression(expression.denominator))
      end

      def derive_expression(expression)
        expression.accept(@deriver)
      end

      def_delegators :@expression_factory,
                     :create_divide_expression, :create_subtract_expression, :create_multiplicate_expression,
                     :create_exponentiate_expression, :create_constant_expression
    end
  end
end
