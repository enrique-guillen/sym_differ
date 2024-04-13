# frozen_string_literal: true

require "spec_helper"
require "sym_differ/subtract_expression"

RSpec.describe SymDiffer::SubtractExpression do
  describe ".new" do
    subject(:new) { described_class.new(minuend, subtrahend) }

    let(:minuend) { double(:minuend) }
    let(:subtrahend) { double(:subtrahend) }

    it { is_expected.to have_attributes(minuend:, subtrahend:) }
  end

  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    let(:expression) { described_class.new(minuend, subtrahend) }
    let(:visitor) { double(:visitor) }

    let(:minuend) { double(:minuend) }
    let(:subtrahend) { double(:subtrahend) }

    before { allow(visitor).to receive(:visit_subtract_expression) }

    it "emits the expected call to the provided visitor" do
      accept
      expect(visitor).to have_received(:visit_subtract_expression).with(expression)
    end
  end
end
