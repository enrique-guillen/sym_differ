# frozen_string_literal: true

require "sym_differ/first_order_differential_equation_approximator"
require "sym_differ/expression_text_language_compiler/parser"
require "sym_differ/expression_factory"
require "sym_differ/runge_kutta_four_solution_approximator"
require "sym_differ/expression_evaluator_visitor"
require "sym_differ/numerical_analysis/step_range"

module SymDiffer
  # Implements the use case for a user getting the approximation of the solutiuon to a first-order differential
  # equation.
  class GetFirstOrderDifferentialEquationApproximationInteractor
    # Defines the high-level response of this use case.
    OperationResponse = Struct.new(:approximated_solution)

    def approximate_solution(expression_text, undetermined_function_name, variable_name, initial_value_coordinates)
      starting_abscissa = access_asbcissa_of_coordinates(initial_value_coordinates)

      step_range_starting_point = (starting_abscissa + 0.125)
      step_range_last_point = (starting_abscissa + 10.0)
      step_range = build_step_range(step_range_starting_point..step_range_last_point)

      approximated_solution = first_order_differential_equation_approximator.approximate_solution(
        expression_text, undetermined_function_name, variable_name, initial_value_coordinates, step_range
      )

      build_operation_response(approximated_solution)
    end

    private

    def access_asbcissa_of_coordinates(coordinates)
      coordinates[0]
    end

    def build_step_range(range)
      NumericalAnalysis::StepRange.new(range)
    end

    def first_order_differential_equation_approximator
      FirstOrderDifferentialEquationApproximator.new(expression_parser, runge_kutta_four_solution_approximator)
    end

    def build_operation_response(*attributes)
      OperationResponse.new(*attributes)
    end

    def expression_parser
      ExpressionTextLanguageCompiler::Parser.new(expression_factory)
    end

    def runge_kutta_four_solution_approximator
      RungeKuttaFourSolutionApproximator
        .new(expression_evaluator_adapter, 0.125, numerical_analysis_item_factory)
    end

    def expression_factory
      ExpressionFactory.new
    end

    def expression_evaluator_adapter
      ExpressionEvaluatorAdapter.new
    end

    def numerical_analysis_item_factory
      NumericalAnalysisItemFactory.new
    end

    # Adapts the ExpressionEvaluatorVisitor interface to the one expected by the first ODE solution approximator.
    class ExpressionEvaluatorAdapter
      def evaluate(expression, variable_values)
        ExpressionEvaluatorVisitor.new(variable_values).evaluate(expression)
      end
    end
  end
end
