# frozen_string_literal: true

require "sym_differ/subtract_expression"

module SymDiffer
  # Reduces the terms in the provided expression.
  class ExpressionReducer
    def reduce(expression)
      return reduce_sum_expression(expression) if sum_expression?(expression)
      return reduce_subtract_expression(expression) if subtract_expression?(expression)
      return reduce_negate_expression(expression) if negate_expression?(expression)

      expression
    end

    private

    def reduce_sum_expression(expression)
      value, subexp = extract_constant_value_and_subexpression(expression)

      return build_constant_expression(value) if subexp.nil?
      return subexp if value.zero?

      build_sum_expression(subexp, build_constant_expression(value))
    end

    def reduce_subtract_expression(expression)
      total_value, subexp = extract_constant_value_and_subexpression(expression)
      return build_integer_expression(total_value) if subexp.nil?
      return reverse_expression_if_subtract_type_and_subtrahend_negative(subexp) if total_value.zero?

      build_positive_constant_plus_subexpression_as_sum_or_subtraction(total_value, subexp)
    end

    def reduce_negate_expression(expression)
      value, subexpression = extract_constant_value_and_subexpression(expression)
      return build_integer_expression(value) if subexpression.nil?

      expression
    end

    def reverse_expression_if_subtract_type_and_subtrahend_negative(expression)
      return expression unless subtract_expression?(expression) && negate_expression?(expression.subtrahend)

      build_sum_expression(expression.minuend, expression.subtrahend.negated_expression)
    end

    def build_positive_constant_plus_subexpression_as_sum_or_subtraction(total_value, subexp)
      if negate_expression?(subexp)
        return build_subtract_expression(build_integer_expression(total_value), subexp.negated_expression)
      end

      return build_subtract_expression(subexp, build_integer_expression(-total_value)) if total_value.negative?

      build_sum_expression(subexp, build_integer_expression(total_value))
    end

    def extract_constant_value_and_subexpression(expression)
      return extract_constant_value_and_subexpression_of_negate(expression) if negate_expression?(expression)
      return extract_constant_value_and_subexpression_of_constant(expression) if constant_expression?(expression)
      return extract_constant_value_and_subexpression_of_variable(expression) if variable_expression?(expression)
      return extract_constant_value_and_subexpression_of_subtract(expression) if subtract_expression?(expression)

      extract_constant_value_and_subexpression_of_sum(expression)
    end

    def extract_constant_value_and_subexpression_of_negate(expression)
      value, subexpression = extract_constant_value_and_subexpression(expression.negated_expression)

      [-value, subexpression]
    end

    def extract_constant_value_and_subexpression_of_constant(expression)
      [expression.value, nil]
    end

    def extract_constant_value_and_subexpression_of_variable(expression)
      [0, expression]
    end

    def extract_constant_value_and_subexpression_of_subtract(expression)
      subvalue_a, subexp_a = extract_constant_value_and_subexpression(expression.minuend)
      subvalue_b, subexp_b = extract_constant_value_and_subexpression(expression.subtrahend)

      total_value = subvalue_a - subvalue_b

      return [total_value, nil] if subexp_a.nil? && subexp_b.nil?
      return [total_value, subexp_a] if subexp_b.nil?
      return [total_value, subexp_b.negated_expression] if subexp_a.nil? && negate_expression?(subexp_b)
      return [total_value, build_negate_expression(subexp_b)] if subexp_a.nil?

      [total_value, build_subtract_expression(subexp_a, subexp_b)]
    end

    def extract_constant_value_and_subexpression_of_sum(expression)
      subvalue_a, subexp_a = extract_constant_value_and_subexpression(expression.expression_a)
      subvalue_b, subexp_b = extract_constant_value_and_subexpression(expression.expression_b)
      total_value = subvalue_a + subvalue_b

      return [total_value, nil] if subexp_a.nil? && subexp_b.nil?
      return [total_value, subexp_b] if subexp_a.nil?
      return [total_value, subexp_a] if subexp_b.nil?

      [total_value, build_sum_expression(subexp_a, subexp_b)]
    end

    def build_integer_expression(total_value)
      return build_constant_expression(total_value) if total_value.positive? || total_value.zero?

      build_negate_expression(build_constant_expression(-total_value))
    end

    def sum_expression?(expression)
      expression.is_a?(SumExpression)
    end

    def subtract_expression?(expression)
      expression.is_a?(SubtractExpression)
    end

    def constant_expression?(expression)
      expression.is_a?(ConstantExpression)
    end

    def variable_expression?(expression)
      expression.is_a?(VariableExpression)
    end

    def negate_expression?(expression)
      expression.is_a?(NegateExpression)
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

    def build_negate_expression(negated_expression)
      SymDiffer::NegateExpression.new(negated_expression)
    end

    def build_subtract_expression(minuend, subtrahend)
      SymDiffer::SubtractExpression.new(minuend, subtrahend)
    end
  end
end
