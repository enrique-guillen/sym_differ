# frozen_string_literal: true

# require "sym_differ/get_derivative_of_expression_interactor"

Before do
  @params = {
    derivative_expression: "",
    y_variable_name: "", t_variable_name: "",
    initial_value_abscissa: "", initial_value_ordinate: ""
  }
  # @result = { response: nil, raised_exception: nil }
end

After do
  @params = nil
  # @result = nil
end

Given("the user wants the approximation of the equation y_function' = {}") do |derivative_expression|
  @params[:derivative_expression] =
    (derivative_expression == "~empty~" ? "" : derivative_expression)
end

Given("the user sets the initial \\(t-var, y-var) coordinate to \\({}, {})") do |abscissa, ordinate|
  @params[:initial_value_abscissa] =
    (abscissa == "~empty~" ? "" : abscissa)

  @params[:initial_value_ordinate] =
    (ordinate == "~empty~" ? "" : ordinate)
end

Given("the user sets the y-variable name to {}") do |variable_name|
  @params[:y_variable_name] =
    (variable_name == "~empty~" ? "" : variable_name)
end

Given("the user sets the t-variable name to {}") do |variable_name|
  @params[:t_variable_name] =
    (variable_name == "~empty~" ? "" : variable_name)
end

When("the user requests the approximation") do
  pending
end

Then("the approximation operation is successful") do
  pending
end

Then("the approximation operation is unsuccessful") do
  pending
end

Then("the initial values of the approximation are:") do |_docstring|
  pending
end
