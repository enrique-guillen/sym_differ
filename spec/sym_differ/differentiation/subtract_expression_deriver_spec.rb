# frozen_string_literal: true

require "spec_helper"
require "sym_differ/subtract_expression"
require "sym_differ/differentiation/subtract_expression_deriver"

RSpec.describe SymDiffer::Differentiation::SubtractExpressionDeriver do
  describe "#derive" do
    subject(:derive) { described_class.new(differentiation_visitor).derive(expression) }

    let(:expression) { SymDiffer::SubtractExpression.new(minuend_expression, subtrahend_expression) }

    let(:minuend_expression) { double(:minuend_expression) }
    let(:subtrahend_expression) { double(:subtrahend_expression) }

    let(:differentiation_visitor) { double(:differentiation_visitor) }

    let(:minuend_expression_derivative) { double(:minuend_expression_derivative) }
    let(:subtrahend_expression_derivative) { double(:subtrahend_expression_derivative) }

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
        .to have_attributes(minuend: minuend_expression_derivative, subtrahend: subtrahend_expression_derivative)
    end
  end
end
