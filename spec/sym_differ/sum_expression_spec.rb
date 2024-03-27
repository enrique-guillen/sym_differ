# frozen_string_literal: true

require "spec_helper"
require "sym_differ/sum_expression"

RSpec.describe SymDiffer::SumExpression do
  subject(:expression) { described_class.new(expression_a, expression_b) }

  let(:expression_a) { double(:expression_a) }
  let(:expression_b) { double(:expression_b) }

  it { is_expected.to have_attributes(expression_a:, expression_b:) }
end
