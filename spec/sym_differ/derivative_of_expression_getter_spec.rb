# frozen_string_literal: true

require "spec_helper"
require "sym_differ/derivative_of_expression_getter"

RSpec.describe SymDiffer::DerivativeOfExpressionGetter do
  it do
    expect(described_class.new.get("x", "x")).to have_attributes(successful?: true, derivative_expression: "1")
  end
end
