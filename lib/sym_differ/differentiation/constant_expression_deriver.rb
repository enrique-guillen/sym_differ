# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module Differentiation
    # Computes the expression that represents the derivative of a constant function.
    class ConstantExpressionDeriver
      extend Forwardable

      def initialize(expression_factory)
        @expression_factory = expression_factory
      end

      def derive(_expression, _variable)
        create_constant_expression(0)
      end

      def_delegators :@expression_factory, :create_constant_expression
    end
  end
end
