# frozen_string_literal: true

module SymDiffer
  module SvgGraphing
    # Represents an SVG Path shaped after the curve determined by an expression.
    ExpressionGraphView = Struct.new(:text, :path, :style)

    # View representing many expression curves on same image.
    View = Struct.new(:show_total_area_aid, :original_view)
  end
end
