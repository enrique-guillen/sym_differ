# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/negate_expression_deriver"
require "sym_differ/negate_expression"

RSpec.describe SymDiffer::Differentiation::NegateExpressionDeriver do
  describe "#derive" do
    subject(:derive) { described_class.new(deriver).derive(expression) }

    before do
      allow(negated_expression).to receive(:accept).with(deriver).and_return(negated_expression_derivative)
    end

    let(:expression) { negate_expression(negated_expression) }
    let(:deriver) { double(:deriver) }

    let(:negated_expression) { double(:negated_expression) }
    let(:negated_expression_derivative) { double(:negated_expression_derivative) }

    it { is_expected.to have_attributes(negated_expression: negated_expression_derivative) }

    define_method(:negate_expression) do |negated_expression|
      SymDiffer::NegateExpression.new(negated_expression)
    end
  end
end
