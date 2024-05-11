# frozen_string_literal: true

module SymDiffer
  # Evalutes the expression, substituting the variables for the specified numeric values and performing the expression's
  # operations.
  class ExpressionEvaluatorVisitor
    def initialize(variable_values)
      @variable_values = variable_values
    end

    def visit_constant_expression(expression)
      expression.value
    end

    def visit_variable_expression(expression)
      @variable_values.fetch(expression.name, 0)
    end

    def visit_sine_expression(expression)
      angle = evaluate(expression.angle_expression)
      Math.sin(angle)
    end

    def visit_cosine_expression(expression)
      angle = evaluate(expression.angle_expression)
      Math.cos(angle)
    end

    def visit_negate_expression(expression)
      -evaluate(expression.negated_expression)
    end

    def visit_positive_expression(expression)
      evaluate(expression.summand)
    end

    def visit_sum_expression(expression)
      evaluate(expression.expression_a) + evaluate(expression.expression_b)
    end

    def visit_subtract_expression(expression)
      evaluate(expression.minuend) - evaluate(expression.subtrahend)
    end

    def visit_multiplicate_expression(expression)
      evaluate(expression.multiplicand) * evaluate(expression.multiplier)
    end

    private

    def evaluate(expression)
      expression.accept(self)
    end
  end
end
