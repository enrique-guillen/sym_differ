# frozen_string_literal: true

require "sym_differ/derivative_of_expression_getter"
require "sym_differ/free_form_expression_text_language/parser"
require "sym_differ/differentiation/differentiation_visitor"
require "sym_differ/expression_reducer"
require "sym_differ/inline_printing/printing_visitor"

# Temporal implementation of VisitorBuilder.
class DifferentiationVisitorBuilder
  def build(variable)
    SymDiffer::Differentiation::DifferentiationVisitor.new(variable)
  end
end

Before do
  @params = { expression: nil, variable: nil }
end

After do
  @params = nil
  @payload = nil
end

Given("the user wants the derivative of {}") do |expression|
  @params[:expression] = expression
end

Given("the user wants the derivative with respect to {}") do |variable|
  @params[:variable] =
    variable == "~ (no variable specified)" ? "" : variable
end

When("the user requests the derivative") do
  @payload =
    SymDiffer::DerivativeOfExpressionGetter
    .new(SymDiffer::FreeFormExpressionTextLanguage::Parser.new,
         DifferentiationVisitorBuilder.new,
         SymDiffer::ExpressionReducer.new,
         SymDiffer::InlinePrinting::PrintingVisitor.new)
    .get(@params[:expression], @params[:variable])
end

Then("the operation is successful") do
  expect(@payload).to be_successful
end

Then("the operation is unsuccessful") do
  expect(@payload).not_to be_successful
end

Then("the computed derivative is {}") do |derivative_expression|
  expect(@payload).to have_attributes(derivative_expression:)
end
