# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/positive_expression"

RSpec.describe SymDiffer::Expressions::PositiveExpression do
  describe ".initialize" do
    subject(:expression) { described_class.new(summand) }

    let(:summand) { double(:summand) }

    it { is_expected.to have_attributes(summand:) }
  end

  describe "#accept" do
    subject(:accept) { positive_expression.accept(visitor) }

    before { allow(visitor).to receive(:visit_positive_expression) }

    let(:positive_expression) { described_class.new(summand) }
    let(:visitor) { double(:visitor) }
    let(:summand) { double(:summand) }

    it "emits visit_positive_expression command to the visitor" do
      accept
      expect(visitor).to have_received(:visit_positive_expression).with(positive_expression)
    end
  end
end
