# frozen_string_literal: true

require "spec_helper"
require "sym_differ/variable_expression"

RSpec.describe SymDiffer::VariableExpression do
  subject(:expression) { described_class.new("x") }

  it { is_expected.to have_attributes(name: "x") }
end
