# frozen_string_literal: true

require "spec_helper"
require "sym_differ/inline_printing/printing_visitor"
require "sym_differ/constant_expression"

RSpec.describe SymDiffer::InlinePrinting::PrintingVisitor do
  let(:visitor) { described_class.new }

  describe "#visit_constant_expression" do
    subject(:visit_constant_expression) do
      visitor.visit_constant_expression(SymDiffer::ConstantExpression.new(1))
    end

    it { is_expected.to eq("1") }
  end

  describe "#visit_variable_expression" do
    subject(:visit_variable_expression) do
      visitor.visit_variable_expression(SymDiffer::VariableExpression.new("var"))
    end

    it { is_expected.to eq("var") }
  end

  describe "#visit_negate_expression" do
    subject(:visit_negate_expression) do
      visitor.visit_negate_expression(expression)
    end

    before do
      allow(negated_expression)
        .to receive(:accept)
        .with(visitor)
        .and_return("subexp")
    end

    let(:expression) { SymDiffer::NegateExpression.new(negated_expression) }
    let(:negated_expression) { double(:negated_expression) }

    it { is_expected.to eq("-subexp") }
  end

  describe "#visit_sum_expression" do
    subject(:visit_sum_expression) do
      visitor.visit_sum_expression(expression)
    end

    before do
      allow(expression_a)
        .to receive(:accept)
        .with(visitor)
        .and_return("exp_a")

      allow(expression_b)
        .to receive(:accept)
        .with(visitor)
        .and_return("exp_b")
    end

    let(:expression) { SymDiffer::SumExpression.new(expression_a, expression_b) }
    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    it { is_expected.to eq("exp_a + exp_b") }
  end
end
