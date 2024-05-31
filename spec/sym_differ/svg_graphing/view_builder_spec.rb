# frozen_string_literal: true

require "spec_helper"
require "sym_differ/svg_graphing/view_builder"

require "sym_differ/graphing/view"
require "sym_differ/graphing/axis_view"
require "sym_differ/graphing/expression_graph_view"

RSpec.describe SymDiffer::SvgGraphing::ViewBuilder do
  describe "#build" do
    subject(:build) do
      described_class
        .new(numerical_analysis_item_factory)
        .build(original_view, curve_stylings)
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:curve_stylings) { [build_curve_styling("blue", "0.5985")] }

    context "when the expression graph has different ordinate values" do
      let(:original_view) do
        build_view(
          axis_view("t", [-1.0, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0.0], -1.0), # ?
          axis_view("y", [1.0, 1.16, 1.32, 1.48, 1.640, 1.8, 1.96, 2.12, 2.280, 2.44, 2.6], 2.6),
          [expression_graph_view(
            "Expression funtext",
            [create_evaluation_point(-1.0, 1.0), create_evaluation_point(0.0, 2.6)]
          )],
          abscissa_distance: 1.0,
          ordinate_distance: 1.6,
          min_abscissa_value: -1.0,
          max_ordinate_value: 2.6
        )
      end

      let(:scaled_approximation_expression_path) do
        an_object_having_attributes(
          evaluation_points: a_collection_containing_exactly(*scaled_approximation_evaluation_points)
        )
      end

      let(:scaled_approximation_evaluation_points) do
        [same_evaluation_point_as(create_evaluation_point(-100.0, 62.5)),
         same_evaluation_point_as(create_evaluation_point(0.0, 162.5))]
      end

      it "returns the expected curves" do
        expect(build).to have_attributes(
          curves: a_collection_containing_exactly(
            an_object_having_attributes(
              text: "Expression funtext",
              paths: [scaled_approximation_expression_path],
              style: build_curve_styling("blue", "0.5985")
            )
          )
        )
      end

      it "returns the expected original_view.abscissa_axis" do
        expect(build).to have_attributes(
          abscissa_axis: an_object_having_attributes(
            name: "t",
            origin: 100.0,
            number_labels: [-1.0, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0.0]
          )
        )
      end

      it "returns the expected original_view.ordinate_axis" do
        expect(build).to have_attributes(
          ordinate_axis: an_object_having_attributes(
            name: "y",
            origin: 162.5,
            number_labels: [1.0, 1.16, 1.32, 1.48, 1.640, 1.8, 1.96, 2.12, 2.280, 2.44, 2.6]
          )
        )
      end
    end

    context "when the expression graph has the same ordinate values" do
      let(:original_view) do
        build_view(
          axis_view("t", [-1.0, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0.0], -1.0), # ?
          axis_view("y", [2.6, 2.7, 2.8, 2.9, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6], 2.6),
          [expression_graph_view(
            "Expression funtext",
            [create_evaluation_point(-1.0, 1.0), create_evaluation_point(0.0, 2.6)]
          )],
          abscissa_distance: 1.0,
          ordinate_distance: 0.0,
          min_abscissa_value: -1.0,
          max_ordinate_value: 2.6
        )
      end

      it "returns the expected ordinate_axis" do
        expect(build).to have_attributes(
          ordinate_axis: an_object_having_attributes(
            name: "y",
            origin: 102.6,
            number_labels: [2.6, 2.7, 2.8, 2.9, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6]
          )
        )
      end
    end

    context "when the axis labels have more than 3 decimals after the point" do
      let(:original_view) do
        build_view(
          axis_view("t", [-1.0, -0.9989, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0.0], -1.0), # ?
          axis_view("y", [1.0, 1.16666, 1.32, 1.48, 1.640, 1.8, 1.96, 2.12, 2.280, 2.44, 2.6], 2.6),
          [expression_graph_view(
            "Expression funtext",
            [create_evaluation_point(-1.0, 1.0), create_evaluation_point(0.0, 2.6)]
          )],
          abscissa_distance: 1.0,
          ordinate_distance: 1.6,
          min_abscissa_value: -1.0,
          max_ordinate_value: 2.6
        )
      end

      it "returns the expected abscissa_axis" do
        expect(build).to have_attributes(
          abscissa_axis: have_attributes(
            name: "t", origin: 100.0,
            number_labels: [-1.0, -0.999, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0.0]
          )
        )
      end

      it "returns the expected ordinate_axis" do
        expect(build).to have_attributes(
          ordinate_axis: an_object_having_attributes(
            name: "y",
            origin: 162.5,
            number_labels: [1.0, 1.167, 1.32, 1.48, 1.64, 1.8, 1.96, 2.12, 2.28, 2.44, 2.6]
          )
        )
      end
    end

    context "when the rounded axis labels still have more than 7 characters total" do
      let(:original_view) do
        build_view(
          axis_view("t", [-11_111.0, -0.9989, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0.0], -11_111.0),
          axis_view("y", [1.0, 1.16666, 1.32, 1.48, 1.640, 1.8, 1.96, 2.12, 2.280, 22_222.5, 222_222.6], 222_222.6),
          [expression_graph_view(
            "Expression funtext",
            [create_evaluation_point(-1.0, 1.0), create_evaluation_point(0.0, 2.6)]
          )],
          abscissa_distance: 1.0,
          ordinate_distance: 1.6,
          min_abscissa_value: -1.0,
          max_ordinate_value: 2.6
        )
      end

      it "returns the expected abscissa_axis" do
        expect(build).to have_attributes(
          abscissa_axis: an_object_having_attributes(
            name: "t", origin: 1_111_100.0,
            number_labels: ["-1.1e+04", -0.999, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0.0]
          )
        )
      end

      it "returns the expected ordinate_axis" do
        expect(build).to have_attributes(
          ordinate_axis: an_object_having_attributes(
            name: "y", origin: 13_888_912.5,
            number_labels: [1.0, 1.167, 1.32, 1.48, 1.64, 1.8, 1.96, 2.12, 2.28, 22_222.5, "2.2e+05"]
          )
        )
      end
    end

    context "when the expression graph has different defined+undefined ordinate values" do
      let(:original_view) do
        build_view(
          axis_view("t", [-1.0, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0.0], -1.0),
          axis_view("y", [1.0, 1.16, 1.32, 1.48, 1.640, 1.8, 1.96, 2.12, 2.280, 2.44, 2.6], 2.6),
          [expression_graph_view(
            "Expression funtext",
            [create_evaluation_point(-1.0, 1.0), create_evaluation_point(0.0, 1.4),
             create_evaluation_point(0.5, :undefined),
             create_evaluation_point(1.0, 2.0), create_evaluation_point(2.0, 2.6)]
          )],
          abscissa_distance: 1.0,
          ordinate_distance: 1.6,
          min_abscissa_value: -1.0,
          max_ordinate_value: 2.6
        )
      end

      let(:scaled_approximation_expression_path_1) do
        an_object_having_attributes(
          evaluation_points: a_collection_containing_exactly(
            *scaled_approximation_evaluation_points_1
          )
        )
      end

      let(:scaled_approximation_expression_path_2) do
        an_object_having_attributes(
          evaluation_points: a_collection_containing_exactly(
            *scaled_approximation_evaluation_points_2
          )
        )
      end

      let(:scaled_approximation_evaluation_points_1) do
        [same_evaluation_point_as(create_evaluation_point(-100.0, 62.5)),
         same_evaluation_point_as(create_evaluation_point(0.0, 87.5))]
      end

      let(:scaled_approximation_evaluation_points_2) do
        [same_evaluation_point_as(create_evaluation_point(100.0, 125.0)),
         same_evaluation_point_as(create_evaluation_point(200.0, 162.5))]
      end

      it "returns the expected curves" do
        expect(build).to have_attributes(
          curves: a_collection_containing_exactly(
            an_object_having_attributes(
              text: "Expression funtext",
              paths: [scaled_approximation_expression_path_1, scaled_approximation_expression_path_2],
              style: build_curve_styling("blue", "0.5985")
            )
          )
        )
      end
    end

    context "when the expression graph has different defined+consecutive undefined ordinate values" do
      let(:original_view) do
        build_view(
          axis_view("t", [-1.0, -0.9, -0.8, -0.7, -0.6, -0.5, -0.4, -0.3, -0.2, -0.1, 0.0], -1.0),
          axis_view("y", [1.0, 1.16, 1.32, 1.48, 1.640, 1.8, 1.96, 2.12, 2.280, 2.44, 2.6], 2.6),
          [expression_graph_view(
            "Expression funtext",
            [create_evaluation_point(-1.0, 1.0), create_evaluation_point(0.0, 1.4),
             create_evaluation_point(0.5, :undefined),
             create_evaluation_point(0.6, :undefined),
             create_evaluation_point(1.0, 2.0), create_evaluation_point(2.0, 2.6)]
          )],
          abscissa_distance: 1.0,
          ordinate_distance: 1.6,
          min_abscissa_value: -1.0,
          max_ordinate_value: 2.6
        )
      end

      let(:scaled_approximation_expression_path_1) do
        an_object_having_attributes(
          evaluation_points: a_collection_containing_exactly(
            *scaled_approximation_evaluation_points_1
          )
        )
      end

      let(:scaled_approximation_expression_path_2) do
        an_object_having_attributes(
          evaluation_points: a_collection_containing_exactly(
            *scaled_approximation_evaluation_points_2
          )
        )
      end

      let(:scaled_approximation_evaluation_points_1) do
        [same_evaluation_point_as(create_evaluation_point(-100.0, 62.5)),
         same_evaluation_point_as(create_evaluation_point(0.0, 87.5))]
      end

      let(:scaled_approximation_evaluation_points_2) do
        [same_evaluation_point_as(create_evaluation_point(100.0, 125.0)),
         same_evaluation_point_as(create_evaluation_point(200.0, 162.5))]
      end

      it "returns the expected curves" do
        expect(build).to have_attributes(
          curves: a_collection_containing_exactly(
            an_object_having_attributes(
              text: "Expression funtext",
              paths: [scaled_approximation_expression_path_1, scaled_approximation_expression_path_2],
              style: build_curve_styling("blue", "0.5985")
            )
          )
        )
      end
    end

    define_method(:build_view) do |abscissa_axis, ordinate_axis, curves, expression_graph_parameters|
      SymDiffer::Graphing::View.new(
        abscissa_axis,
        ordinate_axis,
        curves,
        expression_graph_parameters
      )
    end

    define_method(:axis_view) do |name, number_labels, origin|
      SymDiffer::Graphing::AxisView.new(name, number_labels, origin)
    end

    define_method(:expression_graph_view) do |text, path|
      SymDiffer::Graphing::ExpressionGraphView.new(text, path)
    end

    define_method(:build_curve_styling) do |color, width|
      { "fill" => "none", "stroke" => color, "stroke-width" => width, "stroke-opacity" => "1" }
    end
  end
end
