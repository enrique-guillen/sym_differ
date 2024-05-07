# frozen_string_literal: true

module SymDiffer
  module Differentiation
    # Computes the expression that represents the derivative of the trigonometric Cosine function.
    class CosineExpressionDeriver
      def initialize(expression_factory, differentiation_visitor)
        @expression_factory = expression_factory
        @differentiation_visitor = differentiation_visitor
      end

      def derive(expression)
        create_multiplicate_expression(
          create_negate_expression(create_sine_expression(expression.angle_expression)),
          derive_expression(expression.angle_expression)
        )
      end

      private

      def derive_expression(expression)
        expression.accept(@differentiation_visitor)
      end

      def create_multiplicate_expression(multiplicand, multiplier)
        @expression_factory.create_multiplicate_expression(multiplicand, multiplier)
      end

      def create_negate_expression(negated_expression)
        @expression_factory.create_negate_expression(negated_expression)
      end

      def create_sine_expression(angle_expression)
        @expression_factory.create_sine_expression(angle_expression)
      end
    end
  end
end
