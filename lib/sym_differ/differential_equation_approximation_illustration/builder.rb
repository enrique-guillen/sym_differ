# frozen_string_literal: true

require "sym_differ/differential_equation_approximation_illustration/graph_parameters_calculator"
require "sym_differ/differential_equation_approximation_illustration/graph_view_generator"

module SymDiffer
  module DifferentialEquationApproximationIllustration
    # Takes the provided approximation expression path; builds an image of the "expression path" representing the
    # provided approximation's curve.
    class Builder
      def initialize(expression_stringifier, view_renderer)
        @expression_stringifier = expression_stringifier
        @view_renderer = view_renderer
      end

      def build(approximation_expression_path, equation_parameters)
        @approximation_expression_path = approximation_expression_path
        @equation_parameters = equation_parameters

        calculate_graph_parameters
          .then { |parameters| generate_graph_view(parameters) }
          .then { |view| render_using_underlying_render(view) }
      end

      private

      def calculate_graph_parameters
        graph_parameters_calculator.calculate(approximation_expression_path)
      end

      def generate_graph_view(parameters)
        graph_view_generator.generate(approximation_expression_path, equation_parameters, parameters)
      end

      def graph_parameters_calculator
        GraphParametersCalculator.new
      end

      def graph_view_generator
        GraphViewGenerator.new(@expression_stringifier)
      end

      def render_using_underlying_render(view)
        @view_renderer.render(view)
      end

      attr_reader :approximation_expression_path, :equation_parameters
    end
  end
end
