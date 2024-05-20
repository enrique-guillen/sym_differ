# frozen_string_literal: true

require "spec_helper"
require "sym_differ/numerical_analysis/evaluation_point"

RSpec.describe SymDiffer::NumericalAnalysis::EvaluationPoint do
  describe "#initialize" do
    subject(:evaluation_point) do
      described_class.new(2, 3)
    end

    it { is_expected.to have_attributes(abscissa: 2, ordinate: 3) }
  end

  describe "#same_as?" do
    subject(:same_as?) do
      evaluation_point.same_as?(other_evaluation_point)
    end

    let(:evaluation_point) { described_class.new(2, 3) }

    context "when other_evaluation_point == (2, 3)" do
      let(:other_evaluation_point) { described_class.new(2, 3) }

      it { is_expected.to be(true) }
    end

    context "when other_evaluation_point == (3, 2)" do
      let(:other_evaluation_point) { described_class.new(3, 2) }

      it { is_expected.to be(false) }
    end
  end
end
