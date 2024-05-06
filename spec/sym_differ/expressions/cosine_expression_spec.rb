# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/cosine_expression"

RSpec.describe SymDiffer::Expressions::CosineExpression do
  describe "#initialize" do
    subject(:expression) { described_class.new(angle_expression) }

    let(:angle_expression) { double(:angle_expression) }

    it { is_expected.to have_attributes(angle_expression:) }
  end

  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    before do
      allow(visitor).to receive(:visit_cosine_expression).with(expression).and_return(visited_expression)
    end

    let(:expression) { described_class.new(angle_expression) }
    let(:angle_expression) { double(:angle_expression) }

    let(:visitor) { double(:visitor) }
    let(:visited_expression) { double(:visited_expression) }

    it { is_expected.to eq(visited_expression) }

    it "emits the corresponding call to the visitor" do
      accept
      expect(visitor).to have_received(:visit_cosine_expression).with(expression)
    end
  end
end
