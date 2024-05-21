# frozen_string_literal: true

require "spec_helper"
require "sym_differ/svg_graphing/first_order_differential_equation_approximation_illustration_view_renderer"

require "sym_differ/svg_graphing/view"

RSpec.describe SymDiffer::SvgGraphing::FirstOrderDifferentialEquationApproximationIllustrationViewRenderer do
  describe "#render" do
    subject(:render) do
      described_class.new(underlying_renderer).render(original_view)
    end

    before { allow(underlying_renderer).to receive(:render).and_return(rendered_view) }

    let(:underlying_renderer) { double(:underlying_renderer) }
    let(:original_view) { double(:original_view) }
    let(:rendered_view) { double(:rendered_view) }

    it { is_expected.to eq(rendered_view) }

    it "returns the expected SvgGraphing::View" do
      render

      expect(underlying_renderer)
        .to have_received(:render)
        .with(
          a_kind_of(SymDiffer::SvgGraphing::View)
            .and(have_attributes(show_total_area_aid: false, original_view:, curve_stylings: all(a_kind_of(Hash))))
        )
    end
  end
end
