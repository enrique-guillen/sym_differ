# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/constant_expression_deriver"
require "sym_differ/expression_factory"

RSpec.describe SymDiffer::Differentiation::ConstantExpressionDeriver do
  describe "#derive" do
    subject(:derive) { described_class.new(expression_factory).derive(expression, variable) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    let(:expression) { constant_expression(1) }
    let(:variable) { "x" }

    it { is_expected.to be_same_as(constant_expression(0)) }

    define_method(:constant_expression) do |value|
      expression_factory.create_constant_expression(value)
    end
  end
end
