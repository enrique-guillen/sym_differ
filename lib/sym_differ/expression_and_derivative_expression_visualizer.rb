# frozen_string_literal: true

require "sym_differ/differentiation_graph/builder"

module SymDiffer
  # Implements the use case for a user getting the graph image of the given expression and its derivative.
  class ExpressionAndDerivativeExpressionVisualizer
    def initialize(expression_text_parser,
                   deriver,
                   expression_reducer,
                   expression_stringifier,
                   expression_path_generator,
                   view_renderer,
                   step_range)
      @expression_text_parser = expression_text_parser
      @deriver = deriver
      @expression_reducer = expression_reducer
      @expression_stringifier = expression_stringifier
      @expression_path_generator = expression_path_generator
      @view_renderer = view_renderer
      @step_range = step_range
    end

    def visualize(expression_text, variable)
      expression = parse_expression_text(expression_text)

      derive_expression(expression)
        .then { |derivative_expression| reduce_expression(derivative_expression) }
        .then { |derivative_expression| build_differentiation_graph(expression, derivative_expression, variable) }
    end

    private

    def parse_expression_text(text)
      @expression_text_parser.parse(text)
    end

    def derive_expression(expression)
      @deriver.derive(expression)
    end

    def reduce_expression(expression)
      @expression_reducer.reduce(expression)
    end

    def build_differentiation_graph(expression, derivative_expression, variable)
      differentiation_graph_builder(variable).build(expression, derivative_expression)
    end

    def differentiation_graph_builder(variable)
      DifferentiationGraph::Builder
        .new(variable, @expression_stringifier, @expression_path_generator, @view_renderer, @step_range)
    end
  end
end
