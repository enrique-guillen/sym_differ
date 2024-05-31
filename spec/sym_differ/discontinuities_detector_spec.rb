# frozen_string_literal: true

require "spec_helper"
require "sym_differ/discontinuities_detector"

RSpec.describe SymDiffer::DiscontinuitiesDetector do
  describe "#find" do
    subject(:find) do
      described_class
        .new(root_finder, expression_walker, numerical_analysis_item_factory)
        .find(expression, variable_name, range)
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:root_finder) { double(:root_finder) }
    let(:expression_walker) { double(:expression_walker) }

    let(:expression) { double(:expression) }
    let(:variable_name) { "x" }
    let(:range) { 0.0..0.125 }

    context "when expression walker yields only once" do
      before do
        allow(expression_walker)
          .to receive(:walk)
          .with(expression, yield_at: %i[divisions])
          .and_yield(division_sub_expression)
      end

      let(:division_sub_expression) do
        double(:division_sub_expression,
               denominator: denominator_sub_expression)
      end

      let(:denominator_sub_expression) { double(:denominator_sub_expression) }

      context "when the answer for the mid-point first guess falls within the provided range" do
        before do
          map_root_finder_responses(from: [denominator_sub_expression, variable_name, 0.0625],
                                    to: 0.0625)
        end

        it { is_expected.to be_same_as(create_evaluation_point(0.0625, :undefined)) }
      end

      context "when the answer for the start-point first guess falls within the provided range" do
        before do
          map_root_finder_responses(from: [denominator_sub_expression, variable_name, 0.0625],
                                    to: 300.0)

          map_root_finder_responses(from: [denominator_sub_expression, variable_name, 0.0],
                                    to: 0.001)
        end

        it { is_expected.to be_same_as(create_evaluation_point(0.001, :undefined)) }
      end

      context "when the answer for the end-point first guess falls within the provided range" do
        before do
          map_root_finder_responses(from: [denominator_sub_expression, variable_name, 0.0625],
                                    to: 300.0)

          map_root_finder_responses(from: [denominator_sub_expression, variable_name, 0.0],
                                    to: -30.0)

          map_root_finder_responses(from: [denominator_sub_expression, variable_name, 0.125],
                                    to: 0.124)
        end

        it { is_expected.to be_same_as(create_evaluation_point(0.124, :undefined)) }
      end

      context "when none of the answers fall within the provided range" do
        before do
          map_root_finder_responses(from: [denominator_sub_expression, variable_name, 0.0625],
                                    to: 300.0)

          map_root_finder_responses(from: [denominator_sub_expression, variable_name, 0.0],
                                    to: -30.0)

          map_root_finder_responses(from: [denominator_sub_expression, variable_name, 0.125],
                                    to: 0.127)
        end

        it { is_expected.to be_nil }
      end

      context "when the first answer is nil and the second one is within the range (clarification)" do
        before do
          map_root_finder_responses(from: [denominator_sub_expression, variable_name, 0.0625],
                                    to: nil)

          map_root_finder_responses(from: [denominator_sub_expression, variable_name, 0.0],
                                    to: 0.001)
        end

        it { is_expected.to be_same_as(create_evaluation_point(0.001, :undefined)) }
      end
    end

    context "when expression walker yields twice and a discontinuity is found for first subexpression" do
      before do
        allow(expression_walker)
          .to receive(:walk)
          .with(expression, yield_at: %i[divisions])
          .and_yield(division_sub_expression_1)
          .and_yield(division_sub_expression_2)

        map_root_finder_responses(from: [denominator_sub_expression_1, variable_name, 0.0625],
                                  to: 0.0625)

        map_root_finder_responses(from: [denominator_sub_expression_2, variable_name, 0.0625],
                                  to: 0.0626)
      end

      let(:division_sub_expression_1) do
        double(:division_sub_expression_1,
               denominator: denominator_sub_expression_1)
      end

      let(:division_sub_expression_2) do
        double(:division_sub_expression_2,
               denominator: denominator_sub_expression_2)
      end

      let(:denominator_sub_expression_1) do
        double(:denominator_sub_expression_1)
      end

      let(:denominator_sub_expression_2) do
        double(:denominator_sub_expression_2)
      end

      it { is_expected.to be_same_as(create_evaluation_point(0.0625, :undefined)) }
    end

    context "when expression walker never yields (clarification)" do
      before do
        allow(expression_walker)
          .to receive(:walk)
          .with(expression, yield_at: %i[divisions])
      end

      it { is_expected.to be_nil }
    end

    define_method(:map_root_finder_responses) do |from:, to:, input: from, output: to|
      allow(root_finder)
        .to receive(:find)
        .with(*input)
        .and_return(output)
    end
  end
end
