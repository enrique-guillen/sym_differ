# frozen_string_literal: true

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
    .new
    .get(@params[:expression], @params[:variable])
end

Then("the derivative expression is {}") do |derivative_expression|
  expect(@payload).to have_attributes(derivative_expression:)
end
