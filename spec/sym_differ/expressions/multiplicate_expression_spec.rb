# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/multiplicate_expression"

RSpec.describe SymDiffer::Expressions::MultiplicateExpression do
  describe ".initialize" do
    subject(:multiplicate_expression) { described_class.new(multiplicand, multiplier) }

    let(:multiplicand) { double(:multiplicand) }
    let(:multiplier) { double(:multiplier) }

    it { is_expected.to have_attributes(multiplicand:, multiplier:) }
  end

  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    before { allow(visitor).to receive(:visit_multiplicate_expression) }

    let(:expression) { described_class.new(multiplicand, multiplier) }
    let(:multiplicand) { double(:multiplicand) }
    let(:multiplier) { double(:multiplier) }
    let(:visitor) { double(:visitor) }

    it "emits the call to visitor.visit_multiplicate_expression" do
      accept
      expect(visitor).to have_received(:visit_multiplicate_expression).with(expression)
    end
  end
end
