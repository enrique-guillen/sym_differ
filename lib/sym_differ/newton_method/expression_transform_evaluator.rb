# frozen_string_literal: true

require "sym_differ/fixed_point_approximator"

module SymDiffer
  module NewtonMethod
    # Wraps the provided ExpressionEvaluator into an evaluator that returns a NewtonTransformed-method whose fixed
    # points approximate the roots of the provided expressions.
    class ExpressionTransformEvaluator
      def initialize(derivative_slope_width, variable_name, expression_evaluator)
        @derivative_slope_width = derivative_slope_width
        @variable_name = variable_name
        @expression_evaluator = expression_evaluator
      end

      def evaluate(expression, variable_values)
        variable_value = variable_values.fetch(@variable_name)

        expression_at_variable_value = evaluate_expression(expression, variable_values)
        return :undefined if undefined_value?(expression_at_variable_value)

        derivative_at_variable_value = numerically_approximate_derivative(expression, variable_value, variable_values)
        return :undefined if undefined_value?(derivative_at_variable_value)

        expression_to_derivative_ratio = expression_at_variable_value / derivative_at_variable_value
        return :undefined if undefined_value?(expression_to_derivative_ratio)

        variable_value - expression_to_derivative_ratio
      rescue FloatDomainError
        :undefined
      end

      private

      def numerically_approximate_derivative(expression, variable_value, variable_values)
        parameter_1 = merge_variable(variable_values, variable_value + @derivative_slope_width)
        parameter_2 = merge_variable(variable_values, variable_value)

        value_1 = evaluate_expression(expression, parameter_1)
        return :undefined if undefined_value?(value_1)

        value_2 = evaluate_expression(expression, parameter_2)
        return :undefined if undefined_value?(value_2)

        slope_height = value_1 - value_2

        value = slope_height / @derivative_slope_width
        return :undefined if undefined_value?(value)

        value
      end

      def merge_variable(variable_values, value)
        variable_values.merge(@variable_name => value)
      end

      def undefined_value?(value)
        [Float::INFINITY, Float::NAN, :undefined].include?(value)
      end

      def evaluate_expression(expression, variable_values)
        @expression_evaluator.evaluate(expression, variable_values)
      end
    end
  end
end
