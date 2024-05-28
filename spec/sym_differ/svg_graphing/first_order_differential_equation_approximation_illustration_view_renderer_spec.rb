# frozen_string_literal: true

require "spec_helper"
require "sym_differ/svg_graphing/first_order_differential_equation_approximation_illustration_view_renderer"

require "sym_differ/svg_graphing/view"

RSpec.describe SymDiffer::SvgGraphing::FirstOrderDifferentialEquationApproximationIllustrationViewRenderer do
  describe "#render" do
    subject(:render) do
      described_class
        .new(numerical_analysis_item_factory, underlying_renderer, view_builder)
        .render(original_view)
    end

    before do
      allow(view_builder)
        .to receive(:build)
        .with(original_view, all(a_kind_of(Hash)))
        .and_return(built_view)

      allow(underlying_renderer).to receive(:render).and_return(rendered_view)
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:underlying_renderer) { double(:underlying_renderer) }
    let(:view_builder) { double(:view_builder) }
    let(:original_view) { double(:original_view) }

    let(:built_view) { double(:built_view) }
    let(:rendered_view) { double(:rendered_view) }

    it { is_expected.to eq(rendered_view) }

    it "renders the view" do
      render

      expect(underlying_renderer).to have_received(:render).with(built_view)
    end
  end
end
