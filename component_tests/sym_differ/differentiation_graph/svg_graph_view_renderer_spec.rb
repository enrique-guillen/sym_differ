# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_graph/svg_graph_view_renderer"

RSpec.describe SymDiffer::DifferentiationGraph::SvgGraphViewRenderer do
  describe "#render" do
    subject(:render) do
      described_class.new.render(view)
    end

    let(:view) do
      double(
        :view,
        show_total_area_aid: true,
        expression_text: "x ^ 2",
        derivative_expression_text: "2 * x",
        abscissa_name: "x",
        ordinate_name: "y",
        ordinate_number_labels: [-10, -8, -6, -4, -2, 0, 2, 4, 6, 8],
        ordinate_offset: 9,
        abscissa_number_labels: [-50, -40, -30, -20, -10, 0, 10, 20, 30, 40, 50],
        abscissa_offset: 0,
        origin_ordinate: 49,
        origin_abscissa: 50,
        expression_path:,
        derivative_expression_path:
      )
    end

    context "when the expression paths have 15 and 2 points respectively" do
      let(:expression_path) { (-7..7).map { |i| [i, i**2] } }

      let(:derivative_expression_path) do
        [-26, 25].map { |i| [i, i * 2] }
      end

      it "can be stored in test artifacts after execution" do
        expect { render }.not_to raise_error
        write_test_artifact_path(prefix_with_class_name("low_precision_path.svg"), render)
      end
    end

    context "when the expression paths have 30 and 2 points respectively" do
      let(:expression_path) do
        [-7, -6.5,
         -6, -5.5,
         -5, -4.5,
         -4, -3.5,
         -3, -2.5,
         -2, -1.5,
         -1, -0.5,
         0, 0.5,
         1, 1.5,
         2, 2.5,
         3, 3.5,
         4, 4.5,
         5, 5.5,
         6, 6.5,
         7].map { |i| [i, i**2] }
      end

      let(:derivative_expression_path) do
        [-26, 25].map { |i| [i, i * 2] }
      end

      it "can be stored in test artifacts after execution" do
        expect { render }.not_to raise_error
        write_test_artifact_path(prefix_with_class_name("high_precision_path.svg"), render)
      end
    end

    define_method(:prefix_with_class_name) do |file_name|
      [filesystem_friendlify_class_name(described_class.name), file_name].join(".")
    end
  end
end
