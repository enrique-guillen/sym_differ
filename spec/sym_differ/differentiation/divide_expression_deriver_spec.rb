# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/divide_expression_deriver"

RSpec.describe SymDiffer::Differentiation::DivideExpressionDeriver do
  describe "#derive" do
    subject(:derive) do
      described_class
        .new(expression_factory, deriver)
        .derive(expression)
    end

    before do
      allow(numerator)
        .to receive(:accept)
        .with(deriver)
        .and_return(numerator_derivative)

      allow(denominator)
        .to receive(:accept)
        .with(deriver)
        .and_return(denominator_derivative)
    end

    let(:expression_factory) { sym_differ_expression_factory }
    let(:deriver) { double(:deriver) }

    let(:expression) { divide_expression(numerator, denominator) }

    let(:numerator) { expression_test_double(:numerator) }
    let(:numerator_derivative) { expression_test_double(:numerator_derivative) }

    let(:denominator) { expression_test_double(:denominator) }
    let(:denominator_derivative) { expression_test_double(:denominator_derivative) }

    it "returns the expected derivative" do
      expect(derive).to be_same_as(
        divide_expression(
          subtract_expression(
            multiplicate_expression(numerator_derivative, denominator),
            multiplicate_expression(numerator, denominator_derivative)
          ),
          exponentiate_expression(denominator, constant_expression(2))
        )
      )
    end
  end
end
