# frozen_string_literal: true

require "sym_differ/get_differential_equation_approximation_interactor"

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

Given("the user wants the approximation of the equation y_function' = {}") do |expression_text|
  @params[:expression_text] =
    (expression_text == "~empty~" ? "" : expression_text)
end

Given("the user sets the initial \\(t-var, y-var) coordinate to \\({}, {})") do |abscissa, ordinate|
  @params[:initial_value_abscissa] = abscissa
  @params[:initial_value_ordinate] = ordinate
end

Given("the user sets the y-variable name to {}") do |variable_name|
  @params[:undetermined_function_name] =
    (variable_name == "~empty~" ? "" : variable_name)
end

Given("the user sets the t-variable name to {}") do |variable_name|
  @params[:variable_name] =
    (variable_name == "~empty~" ? "" : variable_name)
end

When("the user requests the approximation") do
  expression_text = @params.fetch(:expression_text)
  undetermined_function_name = @params.fetch(:undetermined_function_name)
  variable_name = @params.fetch(:variable_name)

  initial_value_coordinates =
    [Float(@params.fetch(:initial_value_abscissa)), Float(@params.fetch(:initial_value_ordinate))]

  @result[:response] =
    SymDiffer::GetDifferentialEquationApproximationInteractor.new.approximate_solution(
      expression_text,
      undetermined_function_name,
      variable_name,
      initial_value_coordinates
    )
rescue SymDiffer::Error => e
  @result[:raised_exception] = e
end

Then("the approximation operation is successful") do
  expect(@result[:raised_exception]).to be_nil
end

Then("the approximation operation is unsuccessful") do
  expect(@result[:raised_exception]).not_to be_nil
end

Then("the initial values of the approximation are:") do |docstring|
  expected_evaluation_points =
    docstring.split("\n").map { |pointstring| pointstring.split(",").map(&:to_f) }

  expected_evaluation_point_matchers =
    expected_evaluation_points.map { |point| an_object_having_attributes(abscissa: point[0], ordinate: point[1]) }

  expect(@result[:response]).to have_attributes(
    approximated_solution: an_object_having_attributes(
      evaluation_points: a_collection_including(*expected_evaluation_point_matchers)
    )
  )
end
