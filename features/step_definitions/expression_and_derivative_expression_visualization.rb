# frozen_string_literal: true

require "sym_differ/visualize_differentiation_interactor"

Before do
  @params = { expression: nil, variable: nil }
end

After do
  @params = nil
  @payload = nil
end

Given("the image is requested of the expression and derivative of {}") do |expression|
  @params[:expression] = expression
end

Given(
  "the image is of the graphs with respect to, and of the derivative of the expression with respect to {}"
) do |variable|
  @params[:variable] = variable
end

When("the image is requested") do
  @payload =
    SymDiffer::VisualizeDifferentiationInteractor
    .new
    .visualize(@params[:expression], @params[:variable])
end

Then("the image is stored with filename: {}") do |filename|
  write_test_artifact_path(filename, @payload.image)
end
