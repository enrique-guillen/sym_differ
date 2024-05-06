# frozen_string_literal: true

require "sym_differ/expression_factory"

module Support
  # Defines DSL methods that create objects via the ExpressionFactory protocol/interface. Allows redefining what the
  # concrete factory is that responds to the methods.
  module SymDifferExpressionFactoryDsl
    def sym_differ_expression_factory
      SymDiffer::ExpressionFactory.new
    end

    def constant_expression(value)
      expression_factory.create_constant_expression(value)
    end

    def variable_expression(name)
      expression_factory.create_variable_expression(name)
    end

    def sum_expression(expression_a, expression_b)
      expression_factory.create_sum_expression(expression_a, expression_b)
    end

    def subtract_expression(expression_a, expression_b)
      expression_factory.create_subtract_expression(expression_a, expression_b)
    end

    def negate_expression(negated_expression)
      expression_factory.create_negate_expression(negated_expression)
    end

    def positive_expression(summand)
      expression_factory.create_positive_expression(summand)
    end

    def multiplicate_expression(multiplicand, multiplier)
      expression_factory.create_multiplicate_expression(multiplicand, multiplier)
    end

    def sine_expression(angle_expression)
      expression_factory.create_sine_expression(angle_expression)
    end

    def derivative_expression(underived_expression, variable)
      expression_factory.create_derivative_expression(underived_expression, variable)
    end
  end
end
