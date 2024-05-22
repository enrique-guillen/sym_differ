# frozen_string_literal: true

require "sym_differ/visualize_expression_and_derivative_expression_interactor"

Before do
  @params = { expression: nil, variable: nil }
end

After do
  @params = nil
  @payload = nil
end

Given("the approximation illustration is requested of the equation y' = {}") do |expression_text|
  @params[:expression_text] =
    (expression_text == "~empty~" ? "" : expression_text)
end

Given(
  "the approximation illustration's initial \\(t-var, y-var) coordinate of the approximation is \\({}, {})"
) do |abs, ord|
  @params[:initial_value_abscissa] = abs
  @params[:initial_value_ordinate] = ord
end

Given("the approximation illustration's y-variable name of the approximation is set to {}") do |variable_name|
  @params[:undetermined_function_name] =
    (variable_name == "~empty~" ? "" : variable_name)
end

Given("the approximation illustration's t-variable name of the approximation is set to {}") do |variable_name|
  @params[:variable_name] =
    (variable_name == "~empty~" ? "" : variable_name)
end

When("the illustration is requested") do
  expression_text = @params.fetch(:expression_text)
  undetermined_function_name = @params.fetch(:undetermined_function_name)
  variable_name = @params.fetch(:variable_name)

  initial_value_coordinates =
    [Float(@params.fetch(:initial_value_abscissa)), Float(@params.fetch(:initial_value_ordinate))]

  @payload =
    SymDiffer::IllustrateDifferentialEquationApproximationInteractor.new.illustrate_approximation(
      expression_text,
      undetermined_function_name,
      variable_name,
      initial_value_coordinates
    )
end
