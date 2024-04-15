# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/negate_expression"

RSpec.describe SymDiffer::Expressions::NegateExpression do
  describe "#initialize" do
    subject(:expression) { described_class.new(negated_expression) }

    let(:negated_expression) { double(:expression) }

    it { is_expected.to have_attributes(negated_expression:) }
  end

  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    before { allow(visitor).to receive(:visit_negate_expression) }

    let(:visitor) { double(:visitor) }
    let(:expression) { described_class.new(negated_expression) }
    let(:negated_expression) { double(:expression) }

    it "emits the visit_negate_expression call on the provided visitor" do
      accept
      expect(visitor).to have_received(:visit_negate_expression).with(expression)
    end
  end
end
