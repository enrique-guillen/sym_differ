# frozen_string_literal: true

require "spec_helper"
require "sym_differ/negate_expression"

RSpec.describe SymDiffer::NegateExpression do
  subject(:expression) { described_class.new(negated_expression) }

  let(:negated_expression) { double(:expression) }

  it { is_expected.to have_attributes(negated_expression:) }
end
