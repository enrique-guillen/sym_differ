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

    def approximate_solution(
      expression_text, undetermined_function_name, variable_name, initial_value_coordinates, step_range
    )
      undetermined_function_name = "y" if undetermined_function_name.empty?
      variable_name = "t" if variable_name.empty?

      @undetermined_function_name = undetermined_function_name
      @variable_name = variable_name
      @initial_value_coordinates = initial_value_coordinates

      validate_variables_and_approximate_solution(expression_text, step_range)
    end

    private

    attr_reader :undetermined_function_name, :variable_name, :initial_value_coordinates

    def validate_variables_and_approximate_solution(expression_text, step_range)
      validate_variable(undetermined_function_name)
      validate_variable(variable_name)

      parse_expression_text(expression_text)
        .then { |expression| approximate_solution_via_approximator(expression, step_range) }
    end

    def validate_variable(variable_name)
      @expression_text_parser.validate_variable(variable_name)
    end

    def parse_expression_text(text)
      @expression_text_parser.parse(text)
    end

    def approximate_solution_via_approximator(expression, step_range)
      @solution_approximator.approximate_solution(
        build_equation_parameters(expression, undetermined_function_name, variable_name, initial_value_coordinates),
        step_range
      )
    end

    def build_equation_parameters(*)
      FirstOrderDifferentialEquationSolution::EquationParameters.new(*)
    end
  end
end
