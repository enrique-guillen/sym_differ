# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/derive_constant_expression"
require "sym_differ/constant_expression"

RSpec.describe SymDiffer::Differentiation::DeriveConstantExpression do
  describe "#derive" do
    subject(:derive) { described_class.new.derive(expression) }

    let(:expression) { SymDiffer::ConstantExpression.new(1) }

    it { is_expected.to have_attributes(value: 0) }
  end
end
