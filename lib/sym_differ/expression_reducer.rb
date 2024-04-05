# frozen_string_literal: true

module SymDiffer
  # Reduces the terms in the provided expression.
  class ExpressionReducer
    def reduce(expression)
      if expression.is_a?(SumExpression)
        reduce_sum_expression(expression)
      else
        expression
      end
    end

    private

    def reduce_sum_expression(expression)
      reduced_expression_a = reduce(expression.expression_a)
      reduced_expression_b = reduce(expression.expression_b)

      result = convert_if_sum_of_two_constant_expressions(reduced_expression_a, reduced_expression_b)

      convert_if_sum_of_constant_and_nested_constant(result)
    end

    def convert_if_sum_of_two_constant_expressions(reduced_expression_a, reduced_expression_b)
      if reduced_expression_a.is_a?(ConstantExpression) && reduced_expression_b.is_a?(ConstantExpression)
        build_constant_expression(reduced_expression_a.value + reduced_expression_b.value)
      else
        build_sum_expression(reduced_expression_a, reduced_expression_b)
      end
    end

    def convert_if_sum_of_constant_and_nested_constant(expression)
      return expression unless expression.is_a?(SumExpression)

      sub_expressions =
        if expression.expression_b.is_a?(SumExpression) && expression.expression_a.is_a?(ConstantExpression)
          combine_constants_of_expressions(expression.expression_a, expression.expression_b)
        elsif expression.expression_a.is_a?(SumExpression) && expression.expression_b.is_a?(ConstantExpression)
          combine_constants_of_expressions(expression.expression_b, expression.expression_a)&.reverse
        end

      return expression if sub_expressions.nil?

      build_sum_expression(sub_expressions[0], sub_expressions[1])
    end

    def combine_constants_of_expressions(constant_expression, sum_expression)
      value_and_sub_expression = extract_value_and_subexpression_from_sum_expression(sum_expression)
      return if value_and_sub_expression.nil?

      value, sub_expression = value_and_sub_expression

      [build_constant_expression(constant_expression.value + value), sub_expression]
    end

    def extract_value_and_subexpression_from_sum_expression(expression)
      # if expression.expression_b.is_a?(SumExpression)
      # retrieve_nested_value_and_build_modified_expression(expression.expression_b)
      # elsif expression.expression_a.is_a?(SumExpression)
      # retrieve_nested_value_and_build_modified_expression(expression.expression_a)

      if expression.expression_b.is_a?(ConstantExpression)
        [expression.expression_b.value, expression.expression_a]
      elsif expression.expression_a.is_a?(ConstantExpression)
        [expression.expression_a.value, expression.expression_b]
      end
    end

    def build_constant_expression(value)
      SymDiffer::ConstantExpression.new(value)
    end

    def build_sum_expression(expression_a, expression_b)
      SymDiffer::SumExpression.new(expression_a, expression_b)
    end

    def build_variable_expression(name)
      SymDiffer::VariableExpression.new(name)
    end
  end
end
