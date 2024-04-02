# frozen_string_literal: true

require "spec_helper"
require "sym_differ/variable_expression"

RSpec.describe SymDiffer::VariableExpression do
  describe "#initialize" do
    subject(:expression) { described_class.new("x") }

    it { is_expected.to have_attributes(name: "x") }
  end

  describe "#accept" do
    subject(:accept) do
      expression.accept(visitor)
    end

    before { allow(visitor).to receive(:visit_variable_expression) }

    let(:expression) { described_class.new("x") }
    let(:visitor) { double(:visitor) }

    it "emits the visit_variable_expression call on the visitor" do
      accept
      expect(visitor).to have_received(:visit_variable_expression).with(expression)
    end
  end
end
