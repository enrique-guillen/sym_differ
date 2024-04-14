# frozen_string_literal: true

require "sym_differ/differentiation/constant_expression_deriver"
require "sym_differ/differentiation/variable_expression_deriver"
require "sym_differ/differentiation/sum_expression_deriver"
require "sym_differ/differentiation/subtract_expression_deriver"

module SymDiffer
  module Differentiation
    # Performs the appropriate differentiation operation on each element of the Expression hierarchy.
    class DifferentiationVisitor
      def initialize(variable)
        @variable = variable
      end

      def visit_constant_expression(expression)
        constant_expression_deriver.derive(expression, @variable)
      end

      def visit_variable_expression(expression)
        variable_expression_deriver.derive(expression, @variable)
      end

      def visit_negate_expression(_expression)
        # @todo
        NegateExpression.new(SymDiffer::ConstantExpression.new(1))
      end

      def visit_sum_expression(expression)
        sum_expression_deriver.derive(expression)
      end

      def visit_subtract_expression(expression)
        subtract_expression_deriver.derive(expression)
      end

      private

      def constant_expression_deriver
        @constant_expression_deriver ||= ConstantExpressionDeriver.new
      end

      def variable_expression_deriver
        @variable_expression_deriver ||= VariableExpressionDeriver.new
      end

      def sum_expression_deriver
        @sum_expression_deriver ||= SumExpressionDeriver.new(self)
      end

      def subtract_expression_deriver
        @subtract_expression_deriver ||= SubtractExpressionDeriver.new(self)
      end
    end
  end
end
