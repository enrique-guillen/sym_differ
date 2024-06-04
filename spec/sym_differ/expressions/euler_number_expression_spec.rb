# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/euler_number_expression"

RSpec.describe SymDiffer::Expressions::EulerNumberExpression do
  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    before { allow(visitor).to receive(:visit_euler_number_expression) }

    let(:expression) { described_class.new }
    let(:visitor) { double(:visitor) }

    it "emits the visit_constant_expression call on the provided visitor" do
      accept
      expect(visitor).to have_received(:visit_euler_number_expression).with(expression)
    end
  end

  describe "#same_as?" do
    subject(:same_as?) { expression.same_as?(other_expression) }

    let(:expression) { described_class.new }

    context "when other_expression is 1" do
      let(:other_expression) { constant_expression(1) }
      let(:expression_factory) { sym_differ_expression_factory }

      it { is_expected.to be(false) }
    end

    context "when other_expression is e" do
      let(:other_expression) { described_class.new }
      let(:expression_factory) { sym_differ_expression_factory }

      it { is_expected.to be(true) }
    end
  end
end
