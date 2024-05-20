# frozen_string_literal: true

module SymDiffer
  module Graphing
    # View representing the expression curve and derivative expression curve on the same image.
    View = Struct.new(:abscissa_axis, :ordinate_axis, :curves)
  end
end
