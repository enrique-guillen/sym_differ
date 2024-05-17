# frozen_string_literal: true

require "sym_differ/first_order_differential_equation_solution/equation_parameters"

module SymDiffer
  # Implements the use case for a user getting the approximation of the solutiuon to a first-order differential
  # equation.
  class FirstOrderDifferentialEquationApproximator
    def initialize(expression_text_parser, solution_approximator)
      @expression_text_parser = expression_text_parser
      @solution_approximator = solution_approximator
    end

    def approximate_solution(expression_text, y_variable_name, t_variable_name, initial_value_coordinates)
      y_variable_name = "y" if y_variable_name.empty?
      t_variable_name = "t" if t_variable_name.empty?

      @y_variable_name = y_variable_name
      @t_variable_name = t_variable_name
      @initial_value_coordinates = initial_value_coordinates

      validate_variables_and_approximate_solution(expression_text)
    end

    private

    attr_reader :y_variable_name, :t_variable_name, :initial_value_coordinates

    def validate_variables_and_approximate_solution(expression_text)
      validate_variable(y_variable_name)
      validate_variable(t_variable_name)

      parse_expression_text(expression_text)
        .then { |expression| approximate_solution_via_approximator(expression) }
    end

    def validate_variable(variable_name)
      @expression_text_parser.validate_variable(variable_name)
    end

    def parse_expression_text(text)
      @expression_text_parser.parse(text)
    end

    def approximate_solution_via_approximator(expression)
      @solution_approximator.approximate_solution(
        build_equation_parameters(expression, y_variable_name, t_variable_name, initial_value_coordinates)
      )
    end

    def build_equation_parameters(*)
      FirstOrderDifferentialEquationSolution::EquationParameters.new(*)
    end
  end
end
