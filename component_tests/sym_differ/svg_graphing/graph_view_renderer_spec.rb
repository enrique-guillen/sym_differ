# frozen_string_literal: true

require "spec_helper"
require "sym_differ/svg_graphing/graph_view_renderer"

require "sym_differ/numerical_analysis/evaluation_point"
require "sym_differ/svg_graphing/view"

RSpec.describe SymDiffer::SvgGraphing::GraphViewRenderer do
  describe "#render" do
    subject(:render) do
      described_class.new.render(svg_view)
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:svg_view) { view(true, abscissa_axis, ordinate_axis, curves) }

    context "when curves = f(x), f'(x), labels in -10..10,-20...100 range" do
      let(:abscissa_axis) do
        double(:abscissa_axis,
               name: "x", origin: 50, number_labels: [-10.0, -8.0, -6.0, -4.0, -2.0, 0, 2.0, 4.0, 6.0, 8.0, 10.0])
      end

      let(:ordinate_axis) do
        double(:ordinate_axis,
               name: "y", origin: 49,
               number_labels: [-20.0, -8.0, 4.0, 16.0, 28.0, 40.0, 52.0, 64.0, 76.0, 88.0, 100.0])
      end

      let(:curves) do
        [expression_graph, derivative_expression_graph]
      end

      let(:expression_graph) do
        double(:expression_graph,
               text: "Expression: f(x)",
               path: expression_path,
               style: { "fill" => "none", "stroke" => "blue", "stroke-width" => "0.5985", "stroke-opacity" => "1" })
      end

      let(:derivative_expression_graph) do
        double(:d_expression_graph,
               text: "Derivative: f'(x)",
               path: derivative_expression_path,
               style: { "fill" => "none", "stroke" => "red", "stroke-width" => "0.3985", "stroke-opacity" => "1" })
      end

      context "when the expression paths have 15 and 2 points respectively" do
        let(:expression_path) do
          create_expression_path(evaluation_points)
        end

        let(:evaluation_points) do
          (-7..7).map { |i| evaluation_point(i, i**2) }
        end

        let(:derivative_expression_path) do
          create_expression_path(derivative_evaluation_points)
        end

        let(:derivative_evaluation_points) do
          [-26, 25].map { |i| evaluation_point(i, i * 2) }
        end

        it "can be stored in test artifacts after execution" do
          expect { render }.not_to raise_error
          write_test_artifact_path(prefix_with_class_name("low_precision_path.svg"), render)
        end
      end

      context "when the expression paths have 30 and 2 points respectively" do
        let(:expression_path) do
          create_expression_path(evaluation_points)
        end

        let(:evaluation_points) do
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
          create_expression_path(derivative_evaluation_points)
        end

        let(:derivative_evaluation_points) do
          [-26, 25].map { |i| evaluation_point(i, i * 2) }
        end

        it "can be stored in test artifacts after execution" do
          expect { render }.not_to raise_error
          write_test_artifact_path(prefix_with_class_name("high_precision_path.svg"), render)
        end
      end
    end

    define_method(:prefix_with_class_name) do |file_name|
      [filesystem_friendlify_class_name(described_class.name), file_name].join(".")
    end

    define_method(:evaluation_point) do |abscissa, ordinate|
      create_evaluation_point(abscissa, ordinate)
    end

    define_method(:view) do |show_total_area_aid, abscissa_axis, ordinate_axis, curves|
      SymDiffer::SvgGraphing::View.new(show_total_area_aid, abscissa_axis, ordinate_axis, curves)
    end
  end
end
