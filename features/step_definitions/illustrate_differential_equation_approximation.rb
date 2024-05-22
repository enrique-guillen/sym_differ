# frozen_string_literal: true

require "sym_differ/illustrate_differential_equation_approximation_interactor"

Before do
  @params = {
    expression_text: "",
    undetermined_function_name: "", variable_name: "",
    initial_value_abscissa: "", initial_value_ordinate: ""
  }
  @result = { response: nil, raised_exception: nil }
end

After do
  @params = nil
  @result = nil
end

Given("the user wants the approximation illustration of the equation y_function' = {}") do |expression_text|
  @params[:expression_text] =
    (expression_text == "~empty~" ? "" : expression_text)
end

Given("the user sets the approximation illustration's initial \\(t-var, y-var) coordinate to \\({}, {})") do |abs, ord|
  @params[:initial_value_abscissa] = abs
  @params[:initial_value_ordinate] = ord
end

Given("the user sets the approximation illustration's y-variable name to {}") do |variable_name|
  @params[:undetermined_function_name] =
    (variable_name == "~empty~" ? "" : variable_name)
end

Given("the user sets the approximation illustration's t-variable name to {}") do |variable_name|
  @params[:variable_name] =
    (variable_name == "~empty~" ? "" : variable_name)
end

When("the user requests the approximation's illustration") do
  expression_text = @params.fetch(:expression_text)
  undetermined_function_name = @params.fetch(:undetermined_function_name)
  variable_name = @params.fetch(:variable_name)

  initial_value_coordinates =
    [Float(@params.fetch(:initial_value_abscissa)), Float(@params.fetch(:initial_value_ordinate))]

  @result[:response] =
    SymDiffer::IllustrateDifferentialEquationApproximationInteractor.new.illustrate_approximation(
      expression_text,
      undetermined_function_name,
      variable_name,
      initial_value_coordinates
    )
rescue SymDiffer::Error => e
  @result[:raised_exception] = e
end

Then("the approximation's illustration is retrieved successfully") do
  expect(@result[:response]).to have_attributes(image: a_kind_of(String))
end

Then("the approximation's illustration is not retrieved successfully") do
  expect(@result[:raised_exception]).not_to be_nil
end
