# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differential_equation_approximation/equation_parameters"

RSpec.describe SymDiffer::DifferentialEquationApproximation::EquationParameters do
  describe "#initialize" do
    subject(:equation_parameters) do
      described_class.new(expression, undetermined_function_name, variable_name, initial_coordinates)
    end

    let(:expression) { double(:expression) }
    let(:undetermined_function_name) { "y" }
    let(:variable_name) { "t" }
    let(:initial_coordinates) { [1, 3] }

    it "has the expected parameters" do
      expect(equation_parameters).to have_attributes(
        expression:, undetermined_function_name:, variable_name:, initial_coordinates:
      )
    end
  end
end
