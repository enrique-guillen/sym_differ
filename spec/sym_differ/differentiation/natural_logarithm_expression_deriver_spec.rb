# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/natural_logarithm_expression_deriver"

RSpec.describe SymDiffer::Differentiation::NaturalLogarithmExpressionDeriver do
  describe "#derive" do
    subject(:derive) do
      described_class
        .new(expression_factory, differentiation_visitor)
        .derive(expression)
    end

    before do
      allow(power)
        .to receive(:accept)
        .with(differentiation_visitor)
        .and_return(power_derivative)
    end

    let(:expression_factory) { sym_differ_expression_factory }
    let(:differentiation_visitor) { double(:differentiation_visitor) }

    let(:expression) { natural_logarithm_expression(power) }
    let(:power) { expression_test_double(:power) }

    let(:power_derivative) { expression_test_double(:power_derivative) }

    it "returns the expected derivative expression" do
      expect(derive).to be_same_as(
        divide_expression(power_derivative, power)
      )
    end
  end
end
