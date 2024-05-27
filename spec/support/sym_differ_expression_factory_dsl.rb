# frozen_string_literal: true

require "sym_differ/expression_factory"

module Support
  # Defines DSL methods that create objects via the ExpressionFactory protocol/interface. Allows redefining what the
  # concrete factory is that responds to the methods.
  module SymDifferExpressionFactoryDsl
    def sym_differ_expression_factory
      SymDiffer::ExpressionFactory.new
    end

    def constant_expression(*)
      expression_factory.create_constant_expression(*)
    end

    def variable_expression(*)
      expression_factory.create_variable_expression(*)
    end

    def sum_expression(*)
      expression_factory.create_sum_expression(*)
    end

    def subtract_expression(*)
      expression_factory.create_subtract_expression(*)
    end

    def negate_expression(*)
      expression_factory.create_negate_expression(*)
    end

    def positive_expression(*)
      expression_factory.create_positive_expression(*)
    end

    def multiplicate_expression(*)
      expression_factory.create_multiplicate_expression(*)
    end

    def sine_expression(*)
      expression_factory.create_sine_expression(*)
    end

    def cosine_expression(*)
      expression_factory.create_cosine_expression(*)
    end

    def derivative_expression(*)
      expression_factory.create_derivative_expression(*)
    end

    def divide_expression(*)
      expression_factory.create_divide_expression(*)
    end

    def exponentiate_expression(*)
      expression_factory.create_exponentiate_expression(*)
    end
  end
end
