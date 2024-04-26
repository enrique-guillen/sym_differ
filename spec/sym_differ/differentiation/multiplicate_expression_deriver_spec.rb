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

    let(:expression) { expression_factory.create_multiplicate_expression(multiplicand, multiplier) }
    let(:differentiation_visitor) { double(:differentiation_visitor) }
    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    let(:multiplicand) { double(:multiplicand) }
    let(:multiplier) { double(:multiplier) }

    let(:multiplicand_derivative) { double(:multiplicand_derivative) }
    let(:multiplier_derivative) { double(:multiplier_derivative) }

    it "returns the expected derivative" do
      expect(derive).to have_attributes(
        expression_a: an_object_having_attributes(
          multiplicand: multiplicand_derivative,
          multiplier:
        ),
        expression_b: an_object_having_attributes(
          multiplicand:,
          multiplier: multiplier_derivative
        )
      )
    end
  end
end
