# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reducer"
require "sym_differ/constant_expression"

RSpec.describe SymDiffer::ExpressionReducer do
  describe "#reduce" do
    subject(:reduce) { described_class.new.reduce(expression) }

    context "when the expression is <ConstantExpression:1>" do
      let(:expression) { SymDiffer::ConstantExpression.new(1) }

      it { is_expected.to have_attributes(value: 1) }
    end
  end
end
