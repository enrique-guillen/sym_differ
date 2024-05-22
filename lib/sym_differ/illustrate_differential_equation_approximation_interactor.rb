# frozen_string_literal: true

require "sym_differ/svg_graphing/first_order_differential_equation_approximation_illustration_view_renderer"
require "sym_differ/first_order_differential_equation_approximator"
require "sym_differ/runge_kutta_four_solution_approximator"
require "sym_differ/expression_text_language_compiler/parser"
require "sym_differ/expression_factory"
require "sym_differ/differential_equation_approximation_illustrator"

module SymDiffer
  # Implements the use case for a user getting the graph image of the approximation to a solution for the given
  # differential equation.
  class IllustrateDifferentialEquationApproximationInteractor
    # Defines the high-level response of this use case.
    OperationResponse = Struct.new(:image)

    def initialize(view_renderer = SvgGraphing::FirstOrderDifferentialEquationApproximationIllustrationViewRenderer.new)
      @view_renderer = view_renderer
    end

    def illustrate_approximation(expression_text, undetermined_function_name, variable_name, initial_value_coordinates)
      starting_abscissa = access_asbcissa_of_coordinates(initial_value_coordinates)

      step_range_starting_point = (starting_abscissa + 0.125)
      step_range_last_point = (starting_abscissa + 10.0)
      step_range = build_step_range(step_range_starting_point..step_range_last_point)

      image = differential_equation_approximation_illustrator.illustrate_approximation(
        expression_text, undetermined_function_name, variable_name, initial_value_coordinates, step_range
      )

      OperationResponse.new(image)
    end

    private

    def access_asbcissa_of_coordinates(coordinates)
      coordinates[0]
    end

    def differential_equation_approximation_illustrator
      DifferentialEquationApproximationIllustrator
        .new(expression_text_parser, stringifier_visitor, runge_kutta_four_solution_approximator, @view_renderer)
    end

    def expression_text_parser
      ExpressionTextLanguageCompiler::Parser.new(expression_factory)
    end

    def runge_kutta_four_solution_approximator
      RungeKuttaFourSolutionApproximator.new(expression_evaluator_adapter, 0.125)
    end

    def expression_factory
      ExpressionFactory.new
    end

    def stringifier_visitor
      StringifierVisitor.new
    end

    def expression_evaluator_adapter
      ExpressionEvaluatorAdapter.new
    end

    def build_step_range(range)
      NumericalAnalysis::StepRange.new(range)
    end

    # Adapts the ExpressionEvaluatorVisitor interface to the one expected by the first ODE solution approximator.
    class ExpressionEvaluatorAdapter
      def evaluate(expression, variable_values)
        ExpressionEvaluatorVisitor.new(variable_values).evaluate(expression)
      end
    end
  end
end
