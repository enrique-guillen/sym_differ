# frozen_string_literal: true

require "sym_differ/visualize_differentiation_interactor"

require "sym_differ/error"

Before do
  @params = { expression: nil, variable: nil }
  @result = { raised_exception: nil }
end

After do
  @params = nil
  @result = nil
end

Given("the user wants the image of the expression and derivative of {}") do |expression|
  @params[:expression] = expression
end

Given("the user wants the image with respect to {}") do |variable|
  @params[:variable] =
    variable == "~ (no variable specified)" ? "" : variable
end

When("the user requests the image") do
  @result[:response] =
    SymDiffer::VisualizeDifferentiationInteractor
    .new
    .visualize(@params[:expression], @params[:variable])
rescue SymDiffer::Error => e
  @result[:raised_exception] = e
end

Then("the image is retrieved successfully") do
  expect(@result[:response]).to have_attributes(image: a_kind_of(String))
end

Then("the image is not retrieved successfully") do
  expect(@result[:raised_exception]).not_to be_nil
end
