# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expressions/multiplicate_expression"

RSpec.describe SymDiffer::Expressions::MultiplicateExpression do
  describe ".initialize" do
    subject(:multiplicate_expression) { described_class.new(multiplicand, multiplier) }

    let(:multiplicand) { double(:multiplicand) }
    let(:multiplier) { double(:multiplier) }

    it { is_expected.to have_attributes(multiplicand:, multiplier:) }
  end
end
