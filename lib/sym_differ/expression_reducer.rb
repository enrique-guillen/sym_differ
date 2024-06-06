# frozen_string_literal: true

require "sym_differ/expressions/constant_expression"
require "sym_differ/expressions/variable_expression"
require "sym_differ/expressions/sum_expression"
require "sym_differ/expressions/subtract_expression"
require "sym_differ/expressions/negate_expression"
require "sym_differ/expressions/positive_expression"
require "sym_differ/expressions/multiplicate_expression"

require "sym_differ/expression_reduction/constant_expression_reducer"
require "sym_differ/expression_reduction/variable_expression_reducer"
require "sym_differ/expression_reduction/negative_expression_reducer"
require "sym_differ/expression_reduction/positive_expression_reducer"
require "sym_differ/expression_reduction/sum_expression_reducer"
require "sym_differ/expression_reduction/subtract_expression_reducer"
require "sym_differ/expression_reduction/multiplicate_expression_reducer"
require "sym_differ/expression_reduction/divide_expression_reducer"
require "sym_differ/expression_reduction/exponentiation_expression_reducer"

module SymDiffer
  # Reduces the terms in the provided expression.
  class ExpressionReducer
    def initialize(expression_factory)
      @expression_factory = expression_factory
    end

    def reduce(expression)
      reduction_analysis(expression)[:reduced_expression]
    end

    def reduction_analysis(expression)
      reduction_analysis_of_expression_if_negate_expression(expression) ||
        reduction_analysis_of_expression_if_constant_expression(expression) ||
        reduction_analysis_of_expression_if_variable_expression(expression) ||
        reduction_analysis_of_expression_if_subtract_expression(expression) ||
        reduction_analysis_of_expression_if_positive_expression(expression) ||
        reduction_analysis_of_expression_if_sum_expression(expression) ||
        reduction_analysis_of_expression_if_multiplicate_expression(expression) ||
        reduction_analysis_of_expression_if_divide_expression(expression) ||
        reduction_analysis_of_expression_if_exponentiate_expression(expression) ||
        default_reduction_analysis(expression)
    end

    private

    def reduction_analysis_of_expression_if_negate_expression(expression)
      reduction_analysis_of_negate(expression) if negate_expression?(expression)
    end

    def reduction_analysis_of_expression_if_constant_expression(expression)
      reduction_analysis_of_constant(expression) if constant_expression?(expression)
    end

    def reduction_analysis_of_expression_if_variable_expression(expression)
      reduction_analysis_of_variable(expression) if variable_expression?(expression)
    end

    def reduction_analysis_of_expression_if_subtract_expression(expression)
      reduction_analysis_of_subtract(expression) if subtract_expression?(expression)
    end

    def reduction_analysis_of_expression_if_positive_expression(expression)
      reduction_analysis_of_positive(expression) if positive_expression?(expression)
    end

    def reduction_analysis_of_expression_if_sum_expression(expression)
      reduction_analysis_of_sum(expression) if sum_expression?(expression)
    end

    def reduction_analysis_of_expression_if_multiplicate_expression(expression)
      reduction_analysis_of_multiplicate(expression) if multiplicate_expression?(expression)
    end

    def reduction_analysis_of_expression_if_divide_expression(expression)
      reduction_analysis_of_divide(expression) if divide_expression?(expression)
    end

    def reduction_analysis_of_expression_if_exponentiate_expression(expression)
      reduction_analysis_of_exponentiate(expression) if exponentiate_expression?(expression)
    end

    def default_reduction_analysis(expression)
      { reduced_expression: expression, sum_partition: [0, expression], factor_partition: [1, expression] }
    end

    def reduction_analysis_of_negate(expression)
      negate_expression_reducer.reduce(expression)
    end

    def reduction_analysis_of_constant(expression)
      constant_expression_reducer.reduce(expression)
    end

    def reduction_analysis_of_variable(expression)
      variable_expression_reducer.reduce(expression)
    end

    def reduction_analysis_of_subtract(expression)
      subtract_expression_reducer.reduce(expression)
    end

    def reduction_analysis_of_positive(expression)
      positive_expression_reducer.reduce(expression)
    end

    def reduction_analysis_of_sum(expression)
      sum_expression_reducer.reduce(expression)
    end

    def reduction_analysis_of_multiplicate(expression)
      multiplicate_expression_reducer.reduce(expression)
    end

    def reduction_analysis_of_divide(expression)
      divide_expression_reducer.reduce(expression)
    end

    def reduction_analysis_of_exponentiate(expression)
      exponentiate_expression_reducer.reduce(expression)
    end

    def negate_expression_reducer
      @negate_expression_reducer ||=
        ExpressionReduction::NegativeExpressionReducer.new(@expression_factory, self)
    end

    def constant_expression_reducer
      @constant_expression_reducer ||=
        ExpressionReduction::ConstantExpressionReducer.new
    end

    def variable_expression_reducer
      @variable_expression_reducer ||=
        ExpressionReduction::VariableExpressionReducer.new
    end

    def subtract_expression_reducer
      @subtract_expression_reducer ||=
        ExpressionReduction::SubtractExpressionReducer.new(@expression_factory, self)
    end

    def positive_expression_reducer
      @positive_expression_reducer ||=
        ExpressionReduction::PositiveExpressionReducer.new(self)
    end

    def sum_expression_reducer
      @sum_expression_reducer ||=
        ExpressionReduction::SumExpressionReducer.new(@expression_factory, self)
    end

    def multiplicate_expression_reducer
      @multiplicate_expression_reducer ||=
        ExpressionReduction::MultiplicateExpressionReducer.new(@expression_factory, self)
    end

    def divide_expression_reducer
      @divide_expression_reducer ||=
        ExpressionReduction::DivideExpressionReducer.new(@expression_factory, self)
    end

    def exponentiate_expression_reducer
      @exponentiate_expression_reducer ||=
        ExpressionReduction::ExponentiationExpressionReducer.new(@expression_factory, self)
    end

    def positive_expression?(expression)
      expression.is_a?(Expressions::PositiveExpression)
    end

    def sum_expression?(expression)
      expression.is_a?(Expressions::SumExpression)
    end

    def multiplicate_expression?(expression)
      expression.is_a?(Expressions::MultiplicateExpression)
    end

    def divide_expression?(expression)
      expression.is_a?(Expressions::DivideExpression)
    end

    def subtract_expression?(expression)
      expression.is_a?(Expressions::SubtractExpression)
    end

    def constant_expression?(expression)
      expression.is_a?(Expressions::ConstantExpression)
    end

    def variable_expression?(expression)
      expression.is_a?(Expressions::VariableExpression)
    end

    def negate_expression?(expression)
      expression.is_a?(Expressions::NegateExpression)
    end

    def exponentiate_expression?(expression)
      expression.is_a?(Expressions::ExponentiateExpression)
    end
  end
end
