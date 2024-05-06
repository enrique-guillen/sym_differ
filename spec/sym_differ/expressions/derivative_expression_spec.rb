# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/derivative_expression"

require "sym_differ/expressions/constant_expression"

RSpec.describe SymDiffer::Expressions::DerivativeExpression do
  describe "#initialize" do
    subject(:expression) { described_class.new(underived_expression, variable) }

    let(:underived_expression) { double(:underived_expression) }
    let(:variable) { double(:variable) }

    it { is_expected.to have_attributes(underived_expression:, variable:) }
  end

  describe "#same_as?" do
    subject(:same_as?) { expression.same_as?(other_expression) }

    let(:expression_factory) { sym_differ_expression_factory }

    let(:expression) { described_class.new(underived_expression, variable) }
    let(:underived_expression) { double(:underived_expression) }
    let(:variable) { double(:variable) }

    context "when other expression = 1" do
      let(:other_expression) { constant_expression(1) }

      it { is_expected.to be(false) }
    end

    context "when other expression = derive_expression(x, x)" do
      before do
        allow(underived_expression).to receive(:same_as?).with(underived_expression).and_return(true)
        allow(variable).to receive(:same_as?).with(variable).and_return(true)
      end

      let(:other_expression) { described_class.new(underived_expression, variable) }

      it { is_expected.to be(true) }
    end

    context "when other expression = derive_expression(x, y)" do
      before do
        allow(underived_expression).to receive(:same_as?).with(underived_expression).and_return(true)
        allow(y_variable).to receive(:same_as?).with(variable).and_return(false)
      end

      let(:other_expression) { described_class.new(underived_expression, y_variable) }
      let(:y_variable) { double(:y_variable) }

      it { is_expected.to be(false) }
    end
  end
end
