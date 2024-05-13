# frozen_string_literal: true

require "sym_differ/differentiation_graph/graph_view_generator"
require "sym_differ/differentiation_graph/expression_path_generator"
require "sym_differ/differentiation_graph/expression_graph_parameters_calculator"

require "sym_differ/expression_evaluator_visitor"

module SymDiffer
  module DifferentiationGraph
    # Takes the provided expression and derivative expression; builds an image of the "expression paths" approximating
    # the provided expression curves.
    class Builder
      def initialize(variable, expression_stringifier, expression_path_generator, view_renderer, step_range)
        @variable = variable
        @expression_stringifier = expression_stringifier
        @expression_path_generator = expression_path_generator
        @view_renderer = view_renderer
        @step_range = step_range
      end

      def build(expression, derivative_expression)
        calculate_graph_parameters(expression, derivative_expression)
          .then { |parameters| generate_view(expression, derivative_expression, parameters) }
          .then { |view| render_view_to_svg(view) }
      end

      private

      def calculate_graph_parameters(expression, derivative_expression)
        expression_graph_parameter_calculator.calculate(expression, derivative_expression)
      end

      def generate_view(expression, derivative_expression, parameters)
        graph_view_generator.generate(expression, derivative_expression, parameters)
      end

      def render_view_to_svg(view)
        @view_renderer.render(view)
      end

      def expression_graph_parameter_calculator
        ExpressionGraphParametersCalculator.new(@variable, @expression_path_generator, @step_range)
      end

      def graph_view_generator
        GraphViewGenerator.new(@variable, @expression_stringifier)
      end
    end
  end
end
