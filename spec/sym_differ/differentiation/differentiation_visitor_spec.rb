# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/differentiation_visitor"

require "sym_differ/constant_expression"

RSpec.describe SymDiffer::Differentiation::DifferentiationVisitor do
  describe "#visit_constant_expression" do
    subject(:visit_constant_expression) do
      described_class.new.visit_constant_expression(expression)
    end

    let(:expression) { SymDiffer::ConstantExpression.new(0) }

    it "returns the result of deriving the constant expression" do
      expect(visit_constant_expression).to have_attributes(value: 0)
    end
  end
end
