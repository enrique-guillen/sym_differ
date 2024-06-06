# frozen_string_literal: true

require "sym_differ/expressions/constant_expression"
require "sym_differ/expressions/variable_expression"
require "sym_differ/expressions/sum_expression"
require "sym_differ/expressions/subtract_expression"
require "sym_differ/expressions/negate_expression"
require "sym_differ/expressions/positive_expression"
require "sym_differ/expressions/multiplicate_expression"
require "sym_differ/expressions/sine_expression"
require "sym_differ/expressions/cosine_expression"
require "sym_differ/expressions/derivative_expression"
require "sym_differ/expressions/divide_expression"
require "sym_differ/expressions/exponentiate_expression"
require "sym_differ/expressions/euler_number_expression"
require "sym_differ/expressions/natural_logarithm_expression"

module SymDiffer
  # Implements an interface that allows the Factory users instantiate expressions regardless of the implementation
  # of the Expressions, e.g., the module and class names.
  class ExpressionFactory
    def create_constant_expression(*)
      Expressions::ConstantExpression.new(*)
    end

    def create_variable_expression(*)
      Expressions::VariableExpression.new(*)
    end

    def create_sum_expression(*)
      Expressions::SumExpression.new(*)
    end

    def create_subtract_expression(*)
      Expressions::SubtractExpression.new(*)
    end

    def create_negate_expression(*)
      Expressions::NegateExpression.new(*)
    end

    def create_positive_expression(*)
      Expressions::PositiveExpression.new(*)
    end

    def create_multiplicate_expression(*)
      Expressions::MultiplicateExpression.new(*)
    end

    def create_sine_expression(*)
      Expressions::SineExpression.new(*)
    end

    def create_cosine_expression(*)
      Expressions::CosineExpression.new(*)
    end

    def create_derivative_expression(*)
      Expressions::DerivativeExpression.new(*)
    end

    def create_divide_expression(*)
      Expressions::DivideExpression.new(*)
    end

    def create_exponentiate_expression(*)
      Expressions::ExponentiateExpression.new(*)
    end

    def create_natural_logarithm_expression(*)
      Expressions::NaturalLogarithmExpression.new(*)
    end

    def create_euler_number_expression
      @create_euler_number_expression ||=
        Expressions::EulerNumberExpression.new
    end
  end
end
