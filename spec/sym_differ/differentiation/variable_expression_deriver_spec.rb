# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/variable_expression_deriver"
require "sym_differ/expression_factory"

RSpec.describe SymDiffer::Differentiation::VariableExpressionDeriver do
  describe "#derive" do
    subject(:derive) { described_class.new(expression_factory).derive(expression, variable) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    context "when the provided variable has name 'var'" do
      let(:variable) { "var" }

      context "when the provided expression is VariableExpression(var)" do
        let(:expression) { variable_expression("var") }

        it { is_expected.to be_same_as(constant_expression(1)) }
      end

      context "when the provided expression is VariableExpression(x)" do
        let(:expression) { variable_expression("x") }

        it { is_expected.to be_same_as(constant_expression(0)) }
      end
    end
  end
end
