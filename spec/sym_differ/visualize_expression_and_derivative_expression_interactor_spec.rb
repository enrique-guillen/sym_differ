# frozen_string_literal: true

require "spec_helper"
require "sym_differ/visualize_expression_and_derivative_expression_interactor"

RSpec.describe SymDiffer::VisualizeExpressionAndDerivativeExpressionInteractor do
  describe "#visualize" do
    subject(:visualize) do
      described_class.new(view_renderer).visualize("2 * x", "x")
    end

    before { allow(view_renderer).to receive(:render).and_return(rendered_view) }

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:view_renderer) { double(:view_renderer) }
    let(:rendered_view) { double(:rendered_view) }

    let(:expected_expression_path) do
      [
        evaluation_point(-10, -20.0), evaluation_point(-8.0, -16.0), evaluation_point(-6.0, -12.0),
        evaluation_point(-4.0, -8.0), evaluation_point(-2.0, -4.0), evaluation_point(0.0, 0.0),
        evaluation_point(2.0, 4.0), evaluation_point(4.0, 8.0), evaluation_point(6.0, 12.0),
        evaluation_point(8.0, 16.0), evaluation_point(10.0, 20.0)
      ]
    end

    let(:expected_derivative_expression_path) do
      [
        evaluation_point(-10.0, 2.0), evaluation_point(-8.0, 2.0), evaluation_point(-6.0, 2.0),
        evaluation_point(-4.0, 2.0), evaluation_point(-2.0, 2.0), evaluation_point(0.0, 2.0),
        evaluation_point(2.0, 2.0), evaluation_point(4.0, 2.0), evaluation_point(6.0, 2.0),
        evaluation_point(8.0, 2.0), evaluation_point(10.0, 2.0)
      ]
    end

    it { is_expected.to have_attributes(image: rendered_view) }

    it "renders the expected abscissa axis" do
      visualize

      expect(view_renderer).to have_received(:render).with(
        an_object_having_attributes(
          abscissa_axis: an_object_having_attributes(
            name: "x", origin: -10.0,
            number_labels: [-10.0, -8.0, -6.0, -4.0, -2.0, 0.0, 2.0, 4.0, 6.0, 8.0, 10.0]
          )
        )
      )
    end

    it "renders the expected ordinate axis" do
      visualize

      expect(view_renderer).to have_received(:render).with(
        an_object_having_attributes(
          ordinate_axis: an_object_having_attributes(
            name: "y", origin: 20.0,
            number_labels: [-20.0, -16.0, -12.0, -8.0, -4.0, 0.0, 4.0, 8.0, 12.0, 16.0, 20.0]
          )
        )
      )
    end

    it "renders the expected expression graph" do
      visualize

      expect(view_renderer).to have_received(:render).with(
        an_object_having_attributes(
          curves: a_collection_including(
            an_object_having_attributes(
              text: "Expression: 2 * x",
              path: a_collection_including(*expected_expression_path.map(&method(:same_evaluation_point_as)))
            )
          )
        )
      )
    end

    it "renders the expected derivative expression graph" do
      visualize

      expect(view_renderer).to have_received(:render).with(
        an_object_having_attributes(
          curves: a_collection_including(
            an_object_having_attributes(
              text: "Derivative: 2",
              path: a_collection_including(*expected_derivative_expression_path.map(&method(:same_evaluation_point_as)))
            )
          )
        )
      )
    end

    define_method(:evaluation_point) do |abscissa, ordinate|
      create_evaluation_point(abscissa, ordinate)
    end
  end
end
