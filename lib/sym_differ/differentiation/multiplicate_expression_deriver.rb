# frozen_string_literal: true

module SymDiffer
  module Differentiation
    # Computes the expression that represents the derivative of a multiplication expression.
    class MultiplicateExpressionDeriver
      def initialize(differentiation_visitor, expression_factory)
        @differentiation_visitor = differentiation_visitor
        @expression_factory = expression_factory
      end

      def derive(expression)
        create_sum_expression(
          create_multiplicate_expression(
            derive_expression(expression.multiplicand),
            expression.multiplier
          ),
          create_multiplicate_expression(
            expression.multiplicand,
            derive_expression(expression.multiplier)
          )
        )
      end

      private

      def create_sum_expression(expression_a, expression_b)
        @expression_factory.create_sum_expression(expression_a, expression_b)
      end

      def create_multiplicate_expression(multiplicand, multiplier)
        @expression_factory.create_multiplicate_expression(multiplicand, multiplier)
      end

      def derive_expression(expression)
        expression.accept(@differentiation_visitor)
      end
    end
  end
end
