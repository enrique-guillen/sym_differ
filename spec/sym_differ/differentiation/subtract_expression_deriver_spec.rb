# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/subtract_expression_deriver"
require "sym_differ/expression_factory"

RSpec.describe SymDiffer::Differentiation::SubtractExpressionDeriver do
  describe "#derive" do
    subject(:derive) { described_class.new(differentiation_visitor, expression_factory).derive(expression) }

    let(:expression) { subtract_expression(minuend_expression, subtrahend_expression) }

    let(:differentiation_visitor) { double(:differentiation_visitor) }
    let(:expression_factory) { sym_differ_expression_factory }

    let(:minuend_expression) { expression_test_double(:minuend_expression) }
    let(:subtrahend_expression) { expression_test_double(:subtrahend_expression) }
    let(:minuend_expression_derivative) { expression_test_double(:minuend_expression_derivative) }
    let(:subtrahend_expression_derivative) { expression_test_double(:subtrahend_expression_derivative) }

    before do
      allow(minuend_expression)
        .to receive(:accept)
        .with(differentiation_visitor)
        .and_return(minuend_expression_derivative)

      allow(subtrahend_expression)
        .to receive(:accept)
        .with(differentiation_visitor)
        .and_return(subtrahend_expression_derivative)
    end

    it "returns the subtraction of the derivative of each subexpression" do
      expect(derive)
        .to be_same_as(subtract_expression(minuend_expression_derivative, subtrahend_expression_derivative))
    end
  end
end
