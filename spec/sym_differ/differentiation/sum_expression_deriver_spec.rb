# frozen_string_literal: true

require "spec_helper"
require "sym_differ/sum_expression"
require "sym_differ/differentiation/sum_expression_deriver"

RSpec.describe SymDiffer::Differentiation::SumExpressionDeriver do
  describe "#derive" do
    subject(:derive) { described_class.new(deriver).derive(expression) }

    before do
      allow(expression_a).to receive(:accept).with(deriver).and_return(expression_a_derivative)
      allow(expression_b).to receive(:accept).with(deriver).and_return(expression_b_derivative)
    end

    let(:expression) { SymDiffer::SumExpression.new(expression_a, expression_b) }
    let(:deriver) { double(:deriver) }

    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }
    let(:expression_a_derivative) { double(:expression_a_derivative) }
    let(:expression_b_derivative) { double(:expression_b_derivative) }

    it { is_expected.to have_attributes(expression_a: expression_a_derivative, expression_b: expression_b_derivative) }
  end
end
