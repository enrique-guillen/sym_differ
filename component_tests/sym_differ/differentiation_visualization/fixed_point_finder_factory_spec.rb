# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_visualization/fixed_point_finder_factory"

require "sym_differ/fixed_point_approximator"

RSpec.describe SymDiffer::DifferentiationVisualization::FixedPointFinderFactory do
  describe "#create" do
    subject(:create) do
      described_class.new.create(nil)
    end

    it { is_expected.to be_a_kind_of(SymDiffer::FixedPointApproximator) }
  end
end
