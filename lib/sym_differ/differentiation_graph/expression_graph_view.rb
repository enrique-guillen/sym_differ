# frozen_string_literal: true

module SymDiffer
  module DifferentiationGraph
    # View representing information related to a specific expression's graph.
    ExpressionGraphView = Struct.new(:text, :path)
  end
end
