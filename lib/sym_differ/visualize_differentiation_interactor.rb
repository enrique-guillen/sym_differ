# frozen_string_literal: true

require "sym_differ/differentiation_visualizer"
require "sym_differ/expression_text_language_compiler/parser"

require "sym_differ/differentiation/differentiation_visitor"

require "sym_differ/expression_reducer"
require "sym_differ/stringifier_visitor"
require "sym_differ/expression_evaluator_visitor"
require "sym_differ/expression_walker_visitor"

require "sym_differ/expression_factory"
require "sym_differ/numerical_analysis/step_range"
require "sym_differ/numerical_analysis_item_factory"

require "sym_differ/discontinuities_detector"
require "sym_differ/newton_method/root_finder"
require "sym_differ/fixed_point_approximator"
require "sym_differ/differentiation_graph/expression_path_generator"
require "sym_differ/svg_graphing/differentiation_graph_view_renderer"

require "sym_differ/differentiation_visualization/expression_evaluator_adapter"
require "sym_differ/differentiation_visualization/fixed_point_finder_factory"

module SymDiffer
  # Implements the use case for a user getting the graph image of an expression and its derivative.
  class VisualizeDifferentiationInteractor
    # Defines the high-level response of this use case.
    OperationResponse = Struct.new(:image)

    def initialize(view_renderer = default_svg_view_renderer)
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

      DifferentiationVisualizer.new(
        expression_parser, expression_differentiation_visitor, expression_reducer, expression_stringifier,
        expression_path_generator, @view_renderer, step_range
      )
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
      SymDiffer::DifferentiationGraph::ExpressionPathGenerator
        .new(0.125, expression_evaluator_adapter, numerical_analysis_item_factory, discontinuities_finder)
    end

    def build_step_range(range)
      NumericalAnalysis::StepRange.new(range)
    end

    def expression_factory
      @expression_factory ||= ExpressionFactory.new
    end

    def discontinuities_finder
      DiscontinuitiesDetector.new(
        newton_method_root_finder,
        expression_walker_visitor,
        numerical_analysis_item_factory
      )
    end

    def newton_method_root_finder
      NewtonMethod::RootFinder
        .new(0.00001, expression_evaluator_adapter, fixed_point_finder_creator)
    end

    def expression_walker_visitor
      ExpressionWalkerVisitor.new({})
    end

    def numerical_analysis_item_factory
      @numerical_analysis_item_factory ||= NumericalAnalysisItemFactory.new
    end

    def expression_evaluator_adapter
      DifferentiationVisualization::ExpressionEvaluatorAdapter.new
    end

    def fixed_point_finder_creator
      DifferentiationVisualization::FixedPointFinderFactory.new
    end

    def default_svg_view_renderer
      SymDiffer::SvgGraphing::DifferentiationGraphViewRenderer
        .new(numerical_analysis_item_factory)
    end
  end
end
