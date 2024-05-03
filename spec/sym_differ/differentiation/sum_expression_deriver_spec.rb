# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/sum_expression_deriver"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::Differentiation::SumExpressionDeriver do
  describe "#derive" do
    subject(:derive) { described_class.new(deriver, expression_factory).derive(expression) }

    before do
      allow(expression_a).to receive(:accept).with(deriver).and_return(expression_a_derivative)
      allow(expression_b).to receive(:accept).with(deriver).and_return(expression_b_derivative)
    end

    let(:expression) { sum_expression(expression_a, expression_b) }
    let(:deriver) { double(:deriver) }
    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    let(:expression_a) { expression_test_double(:expression_a) }
    let(:expression_b) { expression_test_double(:expression_b) }
    let(:expression_a_derivative) { expression_test_double(:expression_a_derivative) }
    let(:expression_b_derivative) { expression_test_double(:expression_b_derivative) }

    it { is_expected.to be_same_as(sum_expression(expression_a_derivative, expression_b_derivative)) }
  end
end
