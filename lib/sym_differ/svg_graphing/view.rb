# frozen_string_literal: true

module SymDiffer
  module SvgGraphing
    ExpressionGraphView = Struct.new(:text, :path, :style)

    # View representing many expression curves on same image.
    View = Struct.new(:show_total_area_aid, :original_view)
  end
end
