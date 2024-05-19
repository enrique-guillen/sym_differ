# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_graph/svg_graph_view_renderer"

require "sym_differ/evaluation_point"

RSpec.describe SymDiffer::DifferentiationGraph::SvgGraphViewRenderer do
  describe "#render" do
    subject(:render) do
      described_class.new.render(view)
    end

    let(:view) do
      double(
        :view,
        show_total_area_aid: true,
        abscissa_axis: double(
          :abscissa_axis,
          name: "x", origin: 50,
          number_labels: [-10.0, -8.0, -6.0, -4.0, -2.0, 0, 2.0, 4.0, 6.0, 8.0, 10.0]
        ),
        ordinate_axis: double(
          :ordinate_axis,
          name: "y", origin: 49,
          number_labels: [-20.0, -8.0, 4.0, 16.0, 28.0, 40.0, 52.0, 64.0, 76.0, 88.0, 100.0]
        ),
        expression_graph: double(:expression_graph, text: "f(x)", path: expression_path),
        derivative_expression_graph: double(:d_expression_graph, text: "f'(x)", path: derivative_expression_path)
      )
    end

    context "when the expression paths have 15 and 2 points respectively" do
      let(:expression_path) { (-7..7).map { |i| evaluation_point(i, i**2) } }

      let(:derivative_expression_path) do
        [-26, 25].map { |i| evaluation_point(i, i * 2) }
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
         7].map { |i| evaluation_point(i, i**2) }
      end

      let(:derivative_expression_path) do
        [-26, 25].map { |i| evaluation_point(i, i * 2) }
      end

      it "can be stored in test artifacts after execution" do
        expect { render }.not_to raise_error
        write_test_artifact_path(prefix_with_class_name("high_precision_path.svg"), render)
      end
    end

    define_method(:prefix_with_class_name) do |file_name|
      [filesystem_friendlify_class_name(described_class.name), file_name].join(".")
    end

    define_method(:evaluation_point) do |abscissa, ordinate|
      SymDiffer::EvaluationPoint.new(abscissa, ordinate)
    end
  end
end
