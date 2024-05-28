# frozen_string_literal: true

module SymDiffer
  module SvgGraphing
    # Represents an SVG Path shaped after the curve determined by an expression.
    ExpressionGraphView = Struct.new(:text, :style, :paths)

    # View representing the axis labeling information and positioning of the curve within the different axis.
    AxisView = Struct.new(:name, :number_labels, :origin)

    # View representing many expression curves on same image.
    View = Struct.new(:show_total_area_aid, :abscissa_axis, :ordinate_axis, :curves)
  end
end
