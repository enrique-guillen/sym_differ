# frozen_string_literal: true

require "spec_helper"
require "sym_differ/constant_expression"

RSpec.describe SymDiffer::ConstantExpression do
  describe "#initialize" do
    subject(:expression) { described_class.new(0) }

    it { is_expected.to have_attributes(value: 0) }
  end

  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    before { allow(visitor).to receive(:visit_constant_expression) }

    let(:expression) { described_class.new(0) }
    let(:visitor) { double(:visitor) }

    it "emits the visit_constant_expression call on the provided visitor" do
      accept
      expect(visitor).to have_received(:visit_constant_expression)
    end
  end
end
