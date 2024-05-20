# frozen_string_literal: true

module SymDiffer
  module SvgGraphing
    # View representing the expression curve and derivative expression curve on the same image.
    View = Struct.new(:show_total_area_aid, :original_view, :curve_stylings)
  end
end
