# frozen_string_literal: true

require "sym_differ/expression_factory"

module Support
  module SymDifferExpressionFactoryDsl
    def current_expression_factory
      expression_factory || SymDiffer::ExpressionFactory.new
    end

    def constant_expression(value)
      current_expression_factory.create_constant_expression(value)
    end

    def variable_expression(name)
      current_expression_factory.create_variable_expression(name)
    end

    def sum_expression(expression_a, expression_b)
      current_expression_factory.create_sum_expression(expression_a, expression_b)
    end

    def subtract_expression(expression_a, expression_b)
      current_expression_factory.create_subtract_expression(expression_a, expression_b)
    end

    def negate_expression(negated_expression)
      current_expression_factory.create_negate_expression(negated_expression)
    end

    def positive_expression(summand)
      current_expression_factory.create_positive_expression(summand)
    end

    def multiplicate_expression(multiplicand, multiplier)
      current_expression_factory.create_multiplicate_expression(multiplicand, multiplier)
    end
  end
end
