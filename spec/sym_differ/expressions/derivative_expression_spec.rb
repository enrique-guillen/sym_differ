# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/derivative_expression"

RSpec.describe SymDiffer::Expressions::DerivativeExpression do
  describe "#initialize" do
    subject(:expression) { described_class.new(underived_expression, variable) }

    let(:underived_expression) { double(:underived_expression) }
    let(:variable) { double(:variable) }

    it { is_expected.to have_attributes(underived_expression:, variable:) }
  end
end
