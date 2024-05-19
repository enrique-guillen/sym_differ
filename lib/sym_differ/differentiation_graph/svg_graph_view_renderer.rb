# frozen_string_literal: true

require "erb"

module SymDiffer
  module DifferentiationGraph
    # Takes the GraphView view with the data necessary to display the provided expression curves.
    class SvgGraphViewRenderer
      def render(view)
        @view = view

        ERB.new(template).result(binding)
      end

      private

      GRID_UNIT_SIZE = 7
      private_constant :GRID_UNIT_SIZE

      attr_reader :view

      def template
        current_file_directory = File.dirname(__FILE__)
        template_filename = "svg_graph_template.r.svg"

        template_path = [current_file_directory, template_filename].join("/")

        File.read(template_path)
      end

      def grid_unit_size
        GRID_UNIT_SIZE
      end

      def calculate_y_placement_of_ordinate_label(index)
        multiply_by_grid_unit_size(index * 10) +
          vertical_offset_for_text_alignment
      end

      def calculate_y_placement_of_ordinate_gridline(index)
        multiply_by_grid_unit_size(index * 10)
      end

      def calculate_x_placement_of_abscissa_label(index)
        multiply_by_grid_unit_size(index * 10)
      end

      def calculate_x_placement_of_abscissa_gridline(index)
        multiply_by_grid_unit_size(index * 10)
      end

      def join_expression_point(point)
        [point.abscissa, -point.ordinate].join(", ")
      end

      def vertical_offset_for_text_alignment
        6
      end

      def multiply_by_grid_unit_size(value)
        value * GRID_UNIT_SIZE
      end
    end
  end
end
