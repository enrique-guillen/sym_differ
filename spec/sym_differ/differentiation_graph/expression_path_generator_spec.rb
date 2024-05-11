# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_graph/expression_path_generator"

require "sym_differ/differentiation_graph/step_range"

RSpec.describe SymDiffer::DifferentiationGraph::ExpressionPathGenerator do
  describe "#generate" do
    subject(:generate) do
      described_class
        .new(step_size, expression_evaluator_builder)
        .generate(expression, variable_name, step_range)
    end

    before do
      add_evaluator_to_builder(expression_evaluator_builder, expression_evaluator_1, "x" => -1)
      add_evaluator_to_builder(expression_evaluator_builder, expression_evaluator_2, "x" => 0)
      add_evaluator_to_builder(expression_evaluator_builder, expression_evaluator_3, "x" => 1)

      map_evaluator_response(expression_evaluator_1, from: expression, to: 10)
      map_evaluator_response(expression_evaluator_2, from: expression, to: 20)
      map_evaluator_response(expression_evaluator_3, from: expression, to: 30)
    end

    let(:expression_evaluator_builder) { double(:expression_evaluator_builder) }
    let(:step_size) { 1 }

    let(:expression) { double(:expression) }
    let(:variable_name) { "x" }

    [1, 2, 3].each do |i|
      let(:"expression_evaluator_#{i}") { double(:"expression_evaluator_#{i}") }
    end

    context "when step range == 2..1" do
      let(:step_range) { graph_step_range(2..1) }

      it "generates the expression path" do
        expect(generate).to eq([])
      end
    end

    context "when step_range == 1..1" do
      let(:step_range) { graph_step_range(1..1) }

      it "generates the expression path" do
        expect(generate).to eq(
          [evaluation_point(1, 30)]
        )
      end
    end

    context "when step_range == -1..1" do
      let(:step_range) { graph_step_range(-1..1) }

      it "generates the expression path" do
        expect(generate).to eq(
          [
            evaluation_point(-1, 10),
            evaluation_point(0, 20),
            evaluation_point(1, 30)
          ]
        )
      end
    end

    define_method(:add_evaluator_to_builder) do |builder, instance_to_return, expected_parameters|
      allow(builder).to receive(:build).with(expected_parameters).and_return(instance_to_return)
    end

    define_method(:map_evaluator_response) do |expression_evaluator, from:, to:, input: from, output: to|
      allow(expression_evaluator).to receive(:evaluate).with(input).and_return(output)
    end

    define_method(:evaluation_point) do |abscissa, ordinate|
      [abscissa, ordinate]
    end

    define_method(:graph_step_range) do |range|
      SymDiffer::DifferentiationGraph::StepRange.new(range)
    end
  end
end
