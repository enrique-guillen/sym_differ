# frozen_string_literal: true

require "spec_helper"
require "sym_differ/constant_expression"

RSpec.describe SymDiffer::ConstantExpression do
  subject(:expression) { described_class.new(0) }

  it { is_expected.to have_attributes(value: 0) }
end
