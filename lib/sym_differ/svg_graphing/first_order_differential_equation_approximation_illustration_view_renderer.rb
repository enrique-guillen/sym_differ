# frozen_string_literal: true

require "sym_differ/svg_graphing/graph_view_renderer"
require "sym_differ/svg_graphing/view_builder"

module SymDiffer
  module SvgGraphing
    # Adapts this module's GraphViewRenderer to the FirstOrderDifferentialEquationApproximationIllustration::View-based
    # interface expected by the differentiation graph submodule, and takes styling decisions that are specific to
    # drawing SVGs.
    class FirstOrderDifferentialEquationApproximationIllustrationViewRenderer
      def initialize(underlying_renderer = GraphViewRenderer.new, view_builder = ViewBuilder.new)
        @underlying_renderer = underlying_renderer
        @view_builder = view_builder
      end

      def render(original_view)
        curve_stylings = [build_curve_styling("blue", "0.5985")]
        svg_view = build_svg_view(original_view, curve_stylings)
        render_using_underlying_render(svg_view)
      end

      private

      def build_curve_styling(color, width)
        { "fill" => "none", "stroke" => color, "stroke-width" => width, "stroke-opacity" => "1" }
      end

      def build_svg_view(original_view, curve_stylings)
        @view_builder.build(original_view, curve_stylings)
      end

      def render_using_underlying_render(svg_view)
        @underlying_renderer.render(svg_view)
      end
    end
  end
end
