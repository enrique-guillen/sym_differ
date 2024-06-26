# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/positive_expression_deriver"
require "sym_differ/expression_factory"

RSpec.describe SymDiffer::Differentiation::PositiveExpressionDeriver do
  describe "#derive" do
    subject(:derive) { described_class.new(deriver).derive(expression) }

    before do
      allow(summand)
        .to receive(:accept)
        .with(deriver)
        .and_return(summand_derivative)
    end

    let(:expression_factory) { sym_differ_expression_factory }
    let(:deriver) { double(:deriver) }
    let(:expression) { positive_expression(summand) }

    let(:summand) { double(:summand) }
    let(:summand_derivative) { double(:summand_derivative) }

    it { is_expected.to eq(summand_derivative) }
  end
end
