# frozen_string_literal: true

module SymDiffer
  module Graphing
    # View representing the axis labeling information and positioning of the curve within the different axis.
    AxisView = Struct.new(:name, :number_labels, :origin)
  end
end
