# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/multiplicate_expression_deriver"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::Differentiation::MultiplicateExpressionDeriver do
  describe "#derive" do
    subject(:derive) do
      described_class.new(differentiation_visitor, expression_factory).derive(expression)
    end

    before do
      allow(multiplicand).to receive(:accept).with(differentiation_visitor).and_return(multiplicand_derivative)
      allow(multiplier).to receive(:accept).with(differentiation_visitor).and_return(multiplier_derivative)
    end

    let(:expression) { multiplicate_expression(multiplicand, multiplier) }
    let(:differentiation_visitor) { double(:differentiation_visitor) }
    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    let(:multiplicand) { expression_test_double(:multiplicand) }
    let(:multiplier) { expression_test_double(:multiplier) }

    let(:multiplicand_derivative) { expression_test_double(:multiplicand_derivative) }
    let(:multiplier_derivative) { expression_test_double(:multiplier_derivative) }

    it "returns the expected derivative" do
      expect(derive).to be_same_as(
        sum_expression(
          multiplicate_expression(multiplicand_derivative, multiplier),
          multiplicate_expression(multiplicand, multiplier_derivative)
        )
      )
    end
  end
end
