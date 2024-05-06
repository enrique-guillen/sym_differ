# frozen_string_literal: true

require "sym_differ/expressions/constant_expression"
require "sym_differ/expressions/variable_expression"
require "sym_differ/expressions/sum_expression"
require "sym_differ/expressions/subtract_expression"
require "sym_differ/expressions/negate_expression"
require "sym_differ/expressions/positive_expression"
require "sym_differ/expressions/multiplicate_expression"
require "sym_differ/expressions/sine_expression"
require "sym_differ/expressions/derivative_expression"

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
      Expressions::SumExpression.new(expression_a, expression_b)
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

    def create_multiplicate_expression(multiplicand, multiplier)
      Expressions::MultiplicateExpression.new(multiplicand, multiplier)
    end

    def create_sine_expression(angle_expression)
      Expressions::SineExpression.new(angle_expression)
    end

    def create_derivative_expression(underived_expression, variable)
      Expressions::DerivativeExpression.new(underived_expression, variable)
    end
  end
end
