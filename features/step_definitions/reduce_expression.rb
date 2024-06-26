# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/parser"
require "sym_differ/expression_reducer"

Before do
  @expression_text = nil
end

After do
  @expression_text = nil
  @payload = nil
end

Given("the expression to reduce is {}") do |expression_text|
  @expression_text = expression_text
end

When("the expression is reduced") do
  expression = parse_expression(@expression_text)

  @payload =
    SymDiffer::ExpressionReducer
    .new(SymDiffer::ExpressionFactory.new)
    .reduce(expression)
end

Then("the result is {}") do |expression_text|
  expect(inline_expression(@payload)).to eq(expression_text)
end
