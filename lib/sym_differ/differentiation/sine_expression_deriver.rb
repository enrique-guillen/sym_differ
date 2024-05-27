# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module Differentiation
    # Computes the expression that represents the derivative of the trigonometric Sine function.
    class SineExpressionDeriver
      extend Forwardable

      def initialize(expression_factory, differentiation_visitor)
        @expression_factory = expression_factory
        @differentiation_visitor = differentiation_visitor
      end

      def derive(expression)
        apply_chain_rule_to_expression(
          create_cosine_expression(expression.angle_expression),
          expression.angle_expression
        )
      end

      private

      def apply_chain_rule_to_expression(derivative_function, parameter_expression)
        create_multiplicate_expression(
          derivative_function,
          derive_expression(parameter_expression)
        )
      end

      def derive_expression(expression)
        expression.accept(@differentiation_visitor)
      end

      def_delegators :@expression_factory, :create_multiplicate_expression, :create_cosine_expression
    end
  end
end
