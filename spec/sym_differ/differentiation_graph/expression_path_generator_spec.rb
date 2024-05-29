# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_graph/expression_path_generator"

require "sym_differ/numerical_analysis/step_range"

RSpec.describe SymDiffer::DifferentiationGraph::ExpressionPathGenerator do
  describe "#generate" do
    subject(:generate) do
      described_class
        .new(step_size, expression_evaluator_builder, numerical_analysis_item_factory, discontinuities_detector)
        .generate(expression, variable_name, step_range)
    end

    before do
      allow(discontinuities_detector).to receive(:find).and_return(nil)
    end

    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }
    let(:expression_evaluator_builder) { double(:expression_evaluator_builder) }
    let(:discontinuities_detector) { double(:discontinuities_detector) }
    let(:step_size) { 1 }

    let(:expression) { double(:expression) }
    let(:variable_name) { "x" }

    [1, 2, 3].each do |i|
      let(:"expression_evaluator_#{i}") { double(:"expression_evaluator_#{i}") }
    end

    context "when expression evaluator returns (-1, 10), (0, 20), (10, 30)" do
      before do
        add_evaluator_to_builder(expression_evaluator_builder, expression_evaluator_1, "x" => -1)
        add_evaluator_to_builder(expression_evaluator_builder, expression_evaluator_2, "x" => 0)
        add_evaluator_to_builder(expression_evaluator_builder, expression_evaluator_3, "x" => 1)

        map_evaluator_response(expression_evaluator_1, from: expression, to: 10)
        map_evaluator_response(expression_evaluator_2, from: expression, to: 20)
        map_evaluator_response(expression_evaluator_3, from: expression, to: 30)
      end

      context "when step range == 2..1" do
        let(:step_range) { create_step_range(2..1) }

        it "generates the expression path" do
          expect(generate).to have_attributes(evaluation_points: [])
        end
      end

      context "when step_range == 1..1" do
        let(:step_range) { create_step_range(1..1) }

        it "generates the expression path" do
          expect(generate).to have_attributes(
            evaluation_points: a_collection_containing_exactly(
              same_evaluation_point_as(create_evaluation_point(1, 30))
            )
          )
        end
      end

      context "when step_range == -1..1" do
        let(:step_range) { create_step_range(-1..1) }

        it "generates the expression path" do
          expect(generate).to have_attributes(
            evaluation_points: a_collection_containing_exactly(
              same_evaluation_point_as(create_evaluation_point(-1, 10)),
              same_evaluation_point_as(create_evaluation_point(0, 20)),
              same_evaluation_point_as(create_evaluation_point(1, 30))
            )
          )
        end
      end

      context "when 1 discontinuity exists in range -1..0" do
        before do
          allow(discontinuities_detector)
            .to receive(:find)
            .with(expression, -1..0)
            .and_return(create_evaluation_point(-0.5, :undefined))
        end

        let(:step_range) { create_step_range(-1..1) }

        it "generates the expression path" do
          expect(generate).to have_attributes(
            evaluation_points: a_collection_containing_exactly(
              same_evaluation_point_as(create_evaluation_point(-1, 10)),
              same_evaluation_point_as(create_evaluation_point(-0.5, :undefined)),
              same_evaluation_point_as(create_evaluation_point(0, 20)),
              same_evaluation_point_as(create_evaluation_point(1, 30))
            )
          )
        end
      end
    end

    define_method(:add_evaluator_to_builder) do |builder, instance_to_return, expected_parameters|
      allow(builder).to receive(:build).with(expected_parameters).and_return(instance_to_return)
    end

    define_method(:map_evaluator_response) do |expression_evaluator, from:, to:, input: from, output: to|
      allow(expression_evaluator).to receive(:evaluate).with(input).and_return(output)
    end
  end
end
