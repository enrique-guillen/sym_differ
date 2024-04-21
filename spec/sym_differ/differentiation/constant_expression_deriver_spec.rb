# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/constant_expression_deriver"
require "sym_differ/expression_factory"

RSpec.describe SymDiffer::Differentiation::ConstantExpressionDeriver do
  describe "#derive" do
    subject(:derive) { described_class.new(expression_factory).derive(expression, variable) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    let(:expression) { expression_factory.create_constant_expression(1) }
    let(:variable) { "x" }

    it { is_expected.to have_attributes(value: 0) }
  end
end
