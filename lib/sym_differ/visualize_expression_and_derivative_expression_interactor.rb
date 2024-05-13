# frozen_string_literal: true

require "sym_differ/expression_and_derivative_expression_visualizer"
require "sym_differ/expression_text_language_compiler/parser"
require "sym_differ/differentiation/differentiation_visitor"
require "sym_differ/expression_reducer"
require "sym_differ/stringifier_visitor"
require "sym_differ/differentiation_graph/expression_path_generator"
require "sym_differ/expression_evaluator_visitor"
require "sym_differ/differentiation_graph/svg_graph_view_renderer"
require "sym_differ/differentiation_graph/step_range"

module SymDiffer
  # Implements the use case for a user getting the graph image of an expression and its derivative.
  class VisualizeExpressionAndDerivativeExpressionInteractor
    # Defines the high-level response of this use case.
    OperationResponse = Struct.new(:image)

    def initialize(view_renderer = SymDiffer::DifferentiationGraph::SvgGraphViewRenderer.new)
      @view_renderer = view_renderer
    end

    def visualize(expression_text, variable)
      image = visualizer(variable).visualize(expression_text, variable)

      OperationResponse.new(image)
    end

    private

    def visualizer(variable)
      expression_differentiation_visitor = differentiation_visitor(variable)
      step_range = build_step_range(-10..10)

      ExpressionAndDerivativeExpressionVisualizer.new(expression_parser,
                                                      expression_differentiation_visitor,
                                                      expression_reducer,
                                                      expression_stringifier,
                                                      expression_path_generator,
                                                      @view_renderer,
                                                      step_range)
    end

    def expression_parser
      ExpressionTextLanguageCompiler::Parser.new(expression_factory)
    end

    def differentiation_visitor(variable)
      Differentiation::DifferentiationVisitor.new(variable, expression_factory)
    end

    def expression_reducer
      ExpressionReducer.new(expression_factory)
    end

    def expression_stringifier
      StringifierVisitor.new
    end

    def expression_path_generator
      SymDiffer::DifferentiationGraph::ExpressionPathGenerator.new(0.125, expression_evaluator_builder)
    end

    def build_step_range(range)
      SymDiffer::DifferentiationGraph::StepRange.new(range)
    end

    def expression_evaluator_builder
      ExpressionEvaluatorBuilder.new
    end

    def expression_factory
      @expression_factory = ExpressionFactory.new
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
