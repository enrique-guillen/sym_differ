# frozen_string_literal: true

require "spec_helper"
require "sym_differ/numerical_analysis/expression_path"

RSpec.describe SymDiffer::NumericalAnalysis::ExpressionPath do
  let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

  describe "#initialize" do
    subject(:expression_path) do
      described_class.new(evaluation_points)
    end

    let(:evaluation_points) { [create_evaluation_point(2, 3)] }

    it { is_expected.to have_attributes(evaluation_points:) }
  end

  describe "#add_evaluation_point" do
    subject(:add_evaluation_point) do
      described_class
        .new(existing_evaluation_points)
        .add_evaluation_point(new_evaluation_point)
    end

    let(:existing_evaluation_points) { [create_evaluation_point(1, 2)] }
    let(:new_evaluation_point) { create_evaluation_point(2, 3) }

    it "returns a Path with the new evaluation points" do
      expect(add_evaluation_point).to have_attributes(
        evaluation_points: [
          same_evaluation_point_as(create_evaluation_point(1, 2)),
          same_evaluation_point_as(create_evaluation_point(2, 3))
        ]
      )
    end
  end

  describe "#max_abscissa_value" do
    subject(:max_abscissa_value) do
      described_class
        .new(evaluation_points)
        .max_abscissa_value
    end

    let(:evaluation_points) do
      [
        create_evaluation_point(1, 2),
        create_evaluation_point(2, 3),
        create_evaluation_point(10, 1)
      ]
    end

    it { is_expected.to eq(10) }
  end

  describe "#min_abscissa_value" do
    subject(:min_abscissa_value) do
      described_class
        .new(evaluation_points)
        .min_abscissa_value
    end

    let(:evaluation_points) do
      [
        create_evaluation_point(1, 2),
        create_evaluation_point(2, 3),
        create_evaluation_point(10, 1)
      ]
    end

    it { is_expected.to eq(1) }
  end

  describe "#max_ordinate_value" do
    subject(:max_ordinate_value) do
      described_class
        .new(evaluation_points)
        .max_ordinate_value
    end

    let(:evaluation_points) do
      [
        create_evaluation_point(1, 2),
        create_evaluation_point(2, 3),
        create_evaluation_point(10, 1)
      ]
    end

    it { is_expected.to eq(3) }
  end

  describe "#min_ordinate_value" do
    subject(:min_ordinate_value) do
      described_class
        .new(evaluation_points)
        .min_ordinate_value
    end

    let(:evaluation_points) do
      [
        create_evaluation_point(1, 2),
        create_evaluation_point(2, 3),
        create_evaluation_point(10, 1)
      ]
    end

    it { is_expected.to eq(1) }
  end

  describe "#first_evaluation_point" do
    subject(:first_evaluation_point) do
      described_class
        .new(evaluation_points)
        .first_evaluation_point
    end

    let(:evaluation_points) do
      [
        create_evaluation_point(1, 2),
        create_evaluation_point(2, 3),
        create_evaluation_point(10, 1)
      ]
    end

    it { is_expected.to be_same_as(create_evaluation_point(1, 2)) }
  end

  describe "#last_evaluation_point" do
    subject(:last_evaluation_point) do
      described_class
        .new(evaluation_points)
        .last_evaluation_point
    end

    let(:evaluation_points) do
      [
        create_evaluation_point(1, 2),
        create_evaluation_point(2, 3),
        create_evaluation_point(10, 1)
      ]
    end

    it { is_expected.to be_same_as(create_evaluation_point(10, 1)) }
  end

  describe "#each" do
    let(:evaluation_path) { described_class.new(evaluation_points) }

    let(:evaluation_points) do
      [
        create_evaluation_point(1, 2),
        create_evaluation_point(2, 3),
        create_evaluation_point(10, 1)
      ]
    end

    it "yields a given method with the expected evaluation points" do
      expect { |m| evaluation_path.each(&m) }.to yield_successive_args(
        same_evaluation_point_as(create_evaluation_point(1, 2)),
        same_evaluation_point_as(create_evaluation_point(2, 3)),
        same_evaluation_point_as(create_evaluation_point(10, 1))
      )
    end
  end
end
