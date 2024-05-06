# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/expression"

RSpec.describe SymDiffer::Expressions::Expression do
  describe "#accept" do
    subject(:accept) { expression.accept(visitor) }

    before { allow(visitor).to receive(:visit_abstract_expression).with(expression).and_return(visited_expression) }

    let(:expression) { described_class.new }
    let(:visited_expression) { double(:visited_expression) }
    let(:visitor) { double(:visitor) }

    it "emits the corresponding call to the visitor" do
      accept
      expect(visitor).to have_received(:visit_abstract_expression).with(expression)
    end

    it "returns the result of calling the visitor" do
      expect(accept).to eq(visited_expression)
    end
  end
end
