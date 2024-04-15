# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/sum_expression"

RSpec.describe SymDiffer::Expressions::SumExpression do
  describe "#initialize" do
    subject(:expression) { described_class.new(expression_a, expression_b) }

    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    it { is_expected.to have_attributes(expression_a:, expression_b:) }
  end

  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    before { allow(visitor).to receive(:visit_sum_expression) }

    let(:expression) { described_class.new(expression_a, expression_b) }
    let(:visitor) { double(:visitor) }
    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    it "emits the visit_sum_expression call on the provided visitor" do
      accept
      expect(visitor).to have_received(:visit_sum_expression).with(expression)
    end
  end
end
