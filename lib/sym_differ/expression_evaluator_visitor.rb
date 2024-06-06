# frozen_string_literal: true

module SymDiffer
  # Evalutes the expression, substituting the variables for the specified numeric values and performing the expression's
  # operations.
  class ExpressionEvaluatorVisitor
    def initialize(variable_values)
      @variable_values = variable_values
    end

    def evaluate(expression)
      evaluate_expression(expression)
    end

    def visit_constant_expression(expression)
      expression.value
    end

    def visit_variable_expression(expression)
      @variable_values.fetch(expression.name, 0)
    end

    def visit_sine_expression(expression)
      angle = evaluate_expression(expression.angle_expression)
      Math.sin(angle)
    end

    def visit_cosine_expression(expression)
      angle = evaluate_expression(expression.angle_expression)
      Math.cos(angle)
    end

    def visit_negate_expression(expression)
      -evaluate_expression(expression.negated_expression)
    end

    def visit_positive_expression(expression)
      evaluate_expression(expression.summand)
    end

    def visit_sum_expression(expression)
      evaluate_expression(expression.expression_a) +
        evaluate_expression(expression.expression_b)
    end

    def visit_subtract_expression(expression)
      evaluate_expression(expression.minuend) -
        evaluate_expression(expression.subtrahend)
    end

    def visit_multiplicate_expression(expression)
      evaluate_expression(expression.multiplicand) *
        evaluate_expression(expression.multiplier)
    end

    def visit_divide_expression(expression)
      Rational(
        evaluate_expression(expression.numerator),
        evaluate_expression(expression.denominator)
      )
    end

    def visit_exponentiate_expression(expression)
      evaluate_expression(expression.base)**evaluate_expression(expression.power)
    end

    def visit_euler_number_expression(_expression)
      Math::E
    end

    def visit_natural_logarithm_expression(expression)
      Math.log(evaluate_expression(expression.power))
    end

    private

    def evaluate_expression(expression)
      expression.accept(self)
    end
  end
end
