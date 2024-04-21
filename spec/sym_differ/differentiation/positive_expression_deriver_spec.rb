# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/positive_expression_deriver"
require "sym_differ/positive_expression"

RSpec.describe SymDiffer::Differentiation::PositiveExpressionDeriver do
  describe "#derive" do
    subject(:derive) { described_class.new(deriver).derive(expression) }

    before do
      allow(summand)
        .to receive(:accept)
        .with(deriver)
        .and_return(summand_derivative)
    end

    let(:deriver) { double(:deriver) }
    let(:expression) { SymDiffer::PositiveExpression.new(summand) }
    let(:summand) { double(:summand) }
    let(:summand_derivative) { double(:summand_derivative) }

    it { is_expected.to eq(summand_derivative) }
  end
end
