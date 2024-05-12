# frozen_string_literal: true

module SymDiffer
  module DifferentiationGraph
    # View representing the expression curve and derivative expression curve on the same image.
    View = Struct.new(
      :show_total_area_aid,
      :abscissa_name, :ordinate_name,
      :expression_text, :derivative_expression_text,
      :expression_path, :derivative_expression_path,
      :abscissa_number_labels, :origin_abscissa, :abscissa_offset,
      :ordinate_number_labels, :origin_ordinate, :ordinate_offset
    )
  end
end
