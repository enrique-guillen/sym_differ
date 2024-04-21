# frozen_string_literal: true

require "sym_differ/expressions/constant_expression"
require "sym_differ/expressions/variable_expression"
require "sym_differ/sum_expression"
require "sym_differ/expressions/subtract_expression"
require "sym_differ/expressions/negate_expression"
require "sym_differ/expressions/positive_expression"

module SymDiffer
  # Implements an interface that allows the Factory users instantiate expressions regardless of the implementation
  # of the Expressions, e.g., the module and class names.
  class ExpressionFactory
    def create_constant_expression(value)
      Expressions::ConstantExpression.new(value)
    end

    def create_variable_expression(name)
      Expressions::VariableExpression.new(name)
    end

    def create_sum_expression(expression_a, expression_b)
      SumExpression.new(expression_a, expression_b)
    end

    def create_subtract_expression(minuend, subtrahend)
      Expressions::SubtractExpression.new(minuend, subtrahend)
    end

    def create_negate_expression(negated_expression)
      Expressions::NegateExpression.new(negated_expression)
    end

    def create_positive_expression(summand)
      Expressions::PositiveExpression.new(summand)
    end
  end
end
