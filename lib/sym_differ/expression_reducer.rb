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
      value, subexp = extract_constant_value_and_subexpression(expression)

      if subexp.nil?
        build_constant_expression(value)
      elsif value.zero?
        subexp
      else
        build_sum_expression(subexp, build_constant_expression(value))
      end
    end

    def extract_constant_value_and_subexpression(expression)
      return [expression.value, nil] if expression.is_a?(ConstantExpression)
      return [0, expression] if expression.is_a?(VariableExpression)

      subvalue_a, subexp_a = extract_constant_value_and_subexpression(expression.expression_a)
      subvalue_b, subexp_b = extract_constant_value_and_subexpression(expression.expression_b)
      total_value = subvalue_a + subvalue_b

      return [total_value, nil] if subexp_a.nil? && subexp_b.nil?
      return [total_value, subexp_b] if subexp_a.nil?
      return [total_value, subexp_a] if subexp_b.nil?

      [total_value, build_sum_expression(subexp_a, subexp_b)]
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
