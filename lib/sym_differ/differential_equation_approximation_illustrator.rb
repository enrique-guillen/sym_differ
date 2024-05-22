# frozen_string_literal: true

require "sym_differ/first_order_differential_equation_solution/equation_parameters"
require "sym_differ/first_order_differential_equation_approximation_illustration/builder"

module SymDiffer
  # Implements the use case for a user getting the graph image of the approximation to a solution of a given first order
  # differential equation.
  class DifferentialEquationApproximationIllustrator
    def initialize(expression_text_parser, expression_stringifier, solution_approximator, view_renderer)
      @expression_text_parser = expression_text_parser
      @expression_stringifier = expression_stringifier
      @solution_approximator = solution_approximator
      @view_renderer = view_renderer
    end

    def illustrate_approximation(
      expression_text, undetermined_function_name, variable_name, initial_value_coordinates, step_range
    )
      undetermined_function_name = "y" if undetermined_function_name.empty?
      variable_name = "t" if variable_name.empty?

      @expression_text = expression_text
      @undetermined_function_name = undetermined_function_name
      @variable_name = variable_name
      @initial_value_coordinates = initial_value_coordinates
      @step_range = step_range

      validate_variables_and_illustrate_approximation
    end

    private

    def validate_variables_and_illustrate_approximation
      validate_variable(undetermined_function_name)
      validate_variable(variable_name)

      expression = parse_expression_text(expression_text)

      equation_parameters =
        build_equation_parameters(expression, undetermined_function_name, variable_name, initial_value_coordinates)

      approximated_solution = approximate_solution(equation_parameters, step_range)
      build_graph(approximated_solution, equation_parameters)
    end

    def validate_variable(variable_name)
      @expression_text_parser.validate_variable(variable_name)
    end

    def parse_expression_text(expression_text)
      @expression_text_parser.parse(expression_text)
    end

    def approximate_solution(equation_parameters, step_range)
      @solution_approximator.approximate_solution(equation_parameters, step_range)
    end

    def build_graph(approximated_solution, equation_parameters)
      graph_builder.build(approximated_solution, equation_parameters)
    end

    def graph_builder
      SymDiffer::FirstOrderDifferentialEquationApproximationIllustration::Builder
        .new(@expression_stringifier, @view_renderer)
    end

    def build_equation_parameters(*)
      FirstOrderDifferentialEquationSolution::EquationParameters.new(*)
    end

    attr_reader :expression_text, :undetermined_function_name, :variable_name, :initial_value_coordinates, :step_range
  end
end
