# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/constant_expression_deriver"
require "sym_differ/constant_expression"

RSpec.describe SymDiffer::Differentiation::ConstantExpressionDeriver do
  describe "#derive" do
    subject(:derive) { described_class.new.derive(expression, variable) }

    let(:expression) { SymDiffer::ConstantExpression.new(1) }
    let(:variable) { "x" }

    it { is_expected.to have_attributes(value: 0) }
  end
end
