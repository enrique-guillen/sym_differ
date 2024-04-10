# frozen_string_literal: true

require "sym_differ/get_derivative_of_expression_director"

Before do
  @params = { expression: nil, variable: nil }
  @result = { response: nil, raised_exception: nil }
end

After do
  @params = nil
  @result = nil
end

Given("the user wants the derivative of {}") do |expression|
  @params[:expression] = expression
end

Given("the user wants the derivative with respect to {}") do |variable|
  @params[:variable] =
    variable == "~ (no variable specified)" ? "" : variable
end

When("the user requests the derivative") do
  @result[:response] =
    SymDiffer::GetDerivativeOfExpressionDirector
    .new
    .calculate_derivative(@params[:expression], @params[:variable])
rescue SymDiffer::InvalidVariableGivenToExpressionParserError, SymDiffer::UnparseableExpressionTextError => e
  @result[:raised_exception] = e
end

Then("the operation is successful") do
  expect(@result[:raised_exception]).to be_nil
end

Then("the operation is unsuccessful") do
  expect(@result[:raised_exception]).not_to be_nil
end

Then("the computed derivative is {}") do |derivative_expression|
  expect(@result[:response]).to have_attributes(derivative_expression:)
end
