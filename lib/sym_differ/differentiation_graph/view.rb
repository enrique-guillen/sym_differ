# frozen_string_literal: true

module SymDiffer
  module DifferentiationGraph
    # View representing the expression curve and derivative expression curve on the same image.
    View = Struct.new(
      :show_total_area_aid,
      :abscissa_axis, :ordinate_axis,
      :expression_graph, :derivative_expression_graph
    )
  end
end
