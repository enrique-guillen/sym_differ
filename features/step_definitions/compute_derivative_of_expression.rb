# frozen_string_literal: true

require "sym_differ/derivative_of_expression_getter"
require "sym_differ/free_form_expression_text_language/parser"
require "sym_differ/differentiation/differentiation_visitor"
require "sym_differ/expression_reducer"
require "sym_differ/inline_printing/printing_visitor"

Before do
  @params = { expression: nil, variable: nil }
end

After do
  @params = nil
  @payload = nil
end

Given("the expression to differentiate is {}") do |expression|
  @params[:expression] = expression
end

Given("the variable of the expression to differentiate with is {}") do |variable|
  @params[:variable] =
    variable == "~ (no variable specified)" ? "" : variable
end

When("the expression is computed") do
  @payload =
    SymDiffer::DerivativeOfExpressionGetter
    .new(SymDiffer::FreeFormExpressionTextLanguage::Parser.new,
         DifferentiationVisitorBuilder.new,
         SymDiffer::ExpressionReducer.new,
         SymDiffer::InlinePrinting::PrintingVisitor.new)
    .get(@params[:expression], @params[:variable])
end

Then("the derivative expression is {}") do |derivative_expression|
  expect(@payload).to have_attributes(derivative_expression:)
end
