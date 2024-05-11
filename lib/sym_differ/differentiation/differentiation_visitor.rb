# frozen_string_literal: true

require "sym_differ/differentiation/constant_expression_deriver"
require "sym_differ/differentiation/variable_expression_deriver"
require "sym_differ/differentiation/sum_expression_deriver"
require "sym_differ/differentiation/subtract_expression_deriver"
require "sym_differ/differentiation/negate_expression_deriver"
require "sym_differ/differentiation/positive_expression_deriver"
require "sym_differ/differentiation/multiplicate_expression_deriver"
require "sym_differ/differentiation/sine_expression_deriver"
require "sym_differ/differentiation/cosine_expression_deriver"

module SymDiffer
  module Differentiation
    # Performs the appropriate differentiation operation on each element of the Expression hierarchy.
    class DifferentiationVisitor
      def initialize(variable, expression_factory)
        @variable = variable
        @expression_factory = expression_factory
      end

      def derive(expression)
        expression.accept(self)
      end

      def visit_constant_expression(expression)
        constant_expression_deriver.derive(expression, @variable)
      end

      def visit_variable_expression(expression)
        variable_expression_deriver.derive(expression, @variable)
      end

      def visit_negate_expression(expression)
        negate_expression_deriver.derive(expression)
      end

      def visit_sum_expression(expression)
        sum_expression_deriver.derive(expression)
      end

      def visit_subtract_expression(expression)
        subtract_expression_deriver.derive(expression)
      end

      def visit_positive_expression(expression)
        positive_expression_deriver.derive(expression)
      end

      def visit_multiplicate_expression(expression)
        multiplicate_expression_deriver.derive(expression)
      end

      def visit_sine_expression(expression)
        sine_expression_deriver.derive(expression)
      end

      def visit_cosine_expression(expression)
        cosine_expression_deriver.derive(expression)
      end

      def visit_abstract_expression(expression)
        create_derivative_expression(expression, create_variable_expression(@variable))
      end

      private

      def constant_expression_deriver
        @constant_expression_deriver ||= ConstantExpressionDeriver.new(@expression_factory)
      end

      def variable_expression_deriver
        @variable_expression_deriver ||= VariableExpressionDeriver.new(@expression_factory)
      end

      def negate_expression_deriver
        @negate_expression_deriver ||= NegateExpressionDeriver.new(self, @expression_factory)
      end

      def sum_expression_deriver
        @sum_expression_deriver ||= SumExpressionDeriver.new(self, @expression_factory)
      end

      def subtract_expression_deriver
        @subtract_expression_deriver ||= SubtractExpressionDeriver.new(self, @expression_factory)
      end

      def positive_expression_deriver
        @positive_expression_deriver ||= PositiveExpressionDeriver.new(self)
      end

      def multiplicate_expression_deriver
        @multiplicate_expression_deriver ||= MultiplicateExpressionDeriver.new(self, @expression_factory)
      end

      def sine_expression_deriver
        @sine_expression_deriver ||= SineExpressionDeriver.new(@expression_factory, self)
      end

      def cosine_expression_deriver
        @cosine_expression_deriver ||= CosineExpressionDeriver.new(@expression_factory, self)
      end

      def create_derivative_expression(expression, variable)
        @expression_factory.create_derivative_expression(expression, variable)
      end

      def create_variable_expression(variable)
        @expression_factory.create_variable_expression(variable)
      end
    end
  end
end
