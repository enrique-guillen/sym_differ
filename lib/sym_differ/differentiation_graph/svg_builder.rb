# frozen_string_literal: true

require "sym_differ/differentiation_graph/graph_view_generator"
require "sym_differ/differentiation_graph/expression_path_generator"
require "sym_differ/expression_evaluator_visitor"
require "sym_differ/differentiation_graph/svg_graph_view_renderer"

module SymDiffer
  module DifferentiationGraph
    # Takes the provided expression and derivative expression; builds an image of the "expression paths" approximating
    # the provided expression curves.
    class SvgBuilder
      def initialize(variable, expression_stringifier)
        @variable = variable
        @expression_stringifier = expression_stringifier
      end

      def build(expression, derivative_expression)
        generate_view(expression, derivative_expression)
          .then { |view| render_view_to_svg(view) }
      end

      private

      def generate_view(expression, derivative_expression)
        graph_view_generator.generate(expression, derivative_expression)
      end

      def render_view_to_svg(view)
        svg_graph_view_renderer.render(view)
      end

      def graph_view_generator
        GraphViewGenerator.new(@variable, @expression_stringifier, expression_path_generator)
      end

      def svg_graph_view_renderer
        SvgGraphViewRenderer.new
      end

      def expression_path_generator
        ExpressionPathGenerator.new(0.125, expression_evaluator_builder)
      end

      def expression_evaluator_builder
        ExpressionEvaluatorBuilder.new
      end

      # Builds an instance of an ExpressionEvaluator that will evaluate the expression with the variables set at the
      # specified values.
      class ExpressionEvaluatorBuilder
        def build(variable_values)
          ExpressionEvaluatorVisitor.new(variable_values)
        end
      end
    end
  end
end
