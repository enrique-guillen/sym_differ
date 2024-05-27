# frozen_string_literal: true

module SymDiffer
  module Differentiation
    # Computes the expresion that represents the derivative of the division of two functions.
    class DivideExpressionDeriver
      def initialize(expression_factory, deriver)
        @expression_factory = expression_factory
        @deriver = deriver
      end

      def derive(expression)
        create_divide_expression(
          create_subtract_expression(
            create_multiplicate_expression(derive_expression(expression.numerator), expression.denominator),
            create_multiplicate_expression(expression.numerator, derive_expression(expression.denominator))
          ),
          create_exponentiate_expression(
            expression.denominator, create_constant_expression(2)
          )
        )
      end

      private

      def create_divide_expression(*)
        @expression_factory.create_divide_expression(*)
      end

      def create_subtract_expression(*)
        @expression_factory.create_subtract_expression(*)
      end

      def create_multiplicate_expression(*)
        @expression_factory.create_multiplicate_expression(*)
      end

      def derive_expression(expression)
        expression.accept(@deriver)
      end

      def create_exponentiate_expression(*)
        @expression_factory.create_exponentiate_expression(*)
      end

      def create_constant_expression(*)
        @expression_factory.create_constant_expression(*)
      end
    end
  end
end
