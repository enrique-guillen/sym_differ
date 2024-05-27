# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module Differentiation
    # Computes the expression that represents the derivative of a multiplication expression.
    class MultiplicateExpressionDeriver
      extend Forwardable

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

      def derive_expression(expression)
        expression.accept(@differentiation_visitor)
      end

      def_delegators :@expression_factory, :create_sum_expression, :create_multiplicate_expression
    end
  end
end
