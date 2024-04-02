# frozen_string_literal: true

require "sym_differ/differentiation/constant_expression_deriver"
require "sym_differ/differentiation/variable_expression_deriver"

module SymDiffer
  module Differentiation
    # Performs the appropriate differentiation operation on each element of the Expression hierarchy.
    class DifferentiationVisitor
      def initialize(variable)
        @variable = variable
      end

      def visit_constant_expression(expression)
        ConstantExpressionDeriver.new.derive(expression, @variable)
      end

      def visit_variable_expression(expression)
        VariableExpressionDeriver.new.derive(expression, @variable)
      end

      def visit_negate_expression(_expression)
        # @todo
        NegateExpression.new(SymDiffer::ConstantExpression.new(1))
      end

      def visit_sum_expression(expression)
        SumExpressionDeriver.new(self).derive(expression)
      end
    end
  end
end
