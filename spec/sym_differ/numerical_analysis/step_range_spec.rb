# frozen_string_literal: true

require "spec_helper"
require "sym_differ/numerical_analysis/step_range"

RSpec.describe SymDiffer::NumericalAnalysis::StepRange do
  describe "#first_element" do
    subject(:first_element) do
      described_class.new(range).first_element
    end

    let(:range) { (3..1) }

    it { is_expected.to eq(3) }
  end

  describe "#last_element" do
    subject(:last_element) do
      described_class.new(range).last_element
    end

    let(:range) { (3..1) }

    it { is_expected.to eq(1) }
  end

  describe "#minimum" do
    subject(:minimum) do
      described_class.new(range).minimum
    end

    let(:range) { (5..15) }

    it { is_expected.to eq(5) }
  end

  describe "#maximum" do
    subject(:maximum) do
      described_class.new(range).maximum
    end

    let(:range) { (5..15) }

    it { is_expected.to eq(15) }
  end
end
