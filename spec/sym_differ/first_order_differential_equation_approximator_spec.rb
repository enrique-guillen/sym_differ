# frozen_string_literal: true

require "spec_helper"
require "sym_differ/first_order_differential_equation_approximator"

require "sym_differ/error"

RSpec.describe SymDiffer::FirstOrderDifferentialEquationApproximator do
  describe "#approximate_solution" do
    subject(:approximate_solution) do
      described_class
        .new(expression_text_parser, solution_approximator)
        .approximate_solution(expression_text,
                              undetermined_function_name,
                              variable_name,
                              initial_value_coordinates,
                              step_range)
    end

    before do
      allow(expression_text_parser)
        .to receive(:parse)
        .with("y")
        .and_return(variable_expression("y"))

      allow(expression_text_parser)
        .to receive(:parse)
        .with("")
        .and_raise(SymDiffer::Error, "Invalid expression")

      allow(expression_text_parser).to receive(:validate_variable).with("y").and_return(true)
      allow(expression_text_parser).to receive(:validate_variable).with("x").and_return(true)
      allow(expression_text_parser).to receive(:validate_variable).with("t").and_return(true)

      allow(expression_text_parser)
        .to receive(:validate_variable)
        .with("123invalid")
        .and_raise(SymDiffer::Error, "Invalid variable")
    end

    let(:expression_factory) { sym_differ_expression_factory }

    let(:expression_text_parser) { double(:expression_text_parser) }
    let(:solution_approximator) { double(:solution_approximator) }

    let(:step_range) { double(:step_range) }

    context "when expression = y, y-var name = y, t-var name = x, initial value coordinates = (0, 1)" do
      before do
        allow(solution_approximator)
          .to receive(:approximate_solution)
          .with(
            an_object_having_attributes(
              expression: same_expression_as(variable_expression("y")),
              undetermined_function_name: "y",
              variable_name: "x",
              initial_coordinates: coordinates(0, 1)
            ),
            step_range
          )
          .and_return(solution_approximation)
      end

      let(:expression_text) { "y" }
      let(:undetermined_function_name) { "y" }
      let(:variable_name) { "x" }
      let(:initial_value_coordinates) { coordinates(0, 1) }

      let(:solution_approximation) { double(:solution_approximation) }

      it { is_expected.to eq(solution_approximation) }
    end

    context "when expression = , y-var name = y, t-var name = x, initial value coordinates = (0, 1)" do
      let(:expression_text) { "" }
      let(:undetermined_function_name) { "y" }
      let(:variable_name) { "x" }
      let(:initial_value_coordinates) { coordinates(0, 1) }

      let(:solution_approximation) { double(:solution_approximation) }

      it "lets SymDiffer::Error be raised" do
        expect { approximate_solution }.to raise_error(SymDiffer::Error, "Invalid expression")
      end
    end

    context "when expression = y, y-var name = 123invalid, t-var name = x, initial value coordinates = (0, 1)" do
      let(:expression_text) { "y" }
      let(:undetermined_function_name) { "123invalid" }
      let(:variable_name) { "x" }
      let(:initial_value_coordinates) { coordinates(0, 1) }

      let(:solution_approximation) { double(:solution_approximation) }

      it "lets SymDiffer::Error be raised" do
        expect { approximate_solution }.to raise_error(SymDiffer::Error, "Invalid variable")
      end
    end

    context "when expression = y, y-var name = y, t-var name = 123invalid, initial value coordinates = (0, 1)" do
      let(:expression_text) { "y" }
      let(:undetermined_function_name) { "y" }
      let(:variable_name) { "123invalid" }
      let(:initial_value_coordinates) { coordinates(0, 1) }

      let(:solution_approximation) { double(:solution_approximation) }

      it "lets SymDiffer::Error be raised" do
        expect { approximate_solution }.to raise_error(SymDiffer::Error, "Invalid variable")
      end
    end

    context "when expression = y, y-var name = <empty>, t-var name = <empty>, initial value coordinates = (0, 1)" do
      before do
        allow(solution_approximator)
          .to receive(:approximate_solution)
          .with(
            an_object_having_attributes(
              expression: same_expression_as(variable_expression("y")),
              undetermined_function_name: "y",
              variable_name: "t",
              initial_coordinates: coordinates(0, 1)
            ),
            step_range
          )
          .and_return(solution_approximation)
      end

      let(:expression_text) { "y" }
      let(:undetermined_function_name) { "" }
      let(:variable_name) { "" }
      let(:initial_value_coordinates) { coordinates(0, 1) }

      let(:solution_approximation) { double(:solution_approximation) }

      it { is_expected.to eq(solution_approximation) }
    end

    define_method(:coordinates) do |abscissa, ordinate|
      [abscissa, ordinate]
    end
  end
end
