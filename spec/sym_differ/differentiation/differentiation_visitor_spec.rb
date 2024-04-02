# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/differentiation_visitor"

require "sym_differ/constant_expression"
require "sym_differ/variable_expression"

RSpec.describe SymDiffer::Differentiation::DifferentiationVisitor do
  describe "#visit_constant_expression" do
    subject(:visit_constant_expression) do
      described_class.new(variable).visit_constant_expression(expression)
    end

    let(:expression) { SymDiffer::ConstantExpression.new(0) }
    let(:variable) { "x" }

    it "returns the result of deriving the constant expression" do
      expect(visit_constant_expression).to have_attributes(value: 0)
    end
  end

  describe "#visit_variable_expression" do
    subject(:visit_variable_expression) do
      described_class.new(variable).visit_variable_expression(expression)
    end

    let(:variable) { "x" }

    let(:expression) { SymDiffer::VariableExpression.new("x") }

    it "returns the result of deriving the variable expression" do
      expect(visit_variable_expression).to have_attributes(value: 1)
    end
  end

  describe "#visit_negate_expression" do
    subject(:visit_negate_expression) do
      described_class.new(variable).visit_negate_expression(expression)
    end

    let(:variable) { "x" }
    let(:expression) { SymDiffer::NegateExpression.new(negated_expression) }
    let(:negated_expression) { SymDiffer::VariableExpression.new("x") }

    it "returns the result of deriving the negate expression" do
      expect(visit_negate_expression).to have_attributes(negated_expression: an_object_having_attributes(value: 1))
    end
  end

  describe "#visit_sum_expression" do
    subject(:visit_sum_expression) do
      described_class.new(variable).visit_sum_expression(expression)
    end

    let(:variable) { "x" }
    let(:expression) { SymDiffer::SumExpression.new(expression_a, expression_b) }
    let(:expression_a) { SymDiffer::VariableExpression.new("var") }
    let(:expression_b) { SymDiffer::VariableExpression.new("x") }

    it "returns the result of deriving the sum expression" do
      expect(visit_sum_expression).to have_attributes(
        expression_a: an_object_having_attributes(value: 0),
        expression_b: an_object_having_attributes(value: 1)
      )
    end
  end
end
