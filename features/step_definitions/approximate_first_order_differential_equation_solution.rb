# frozen_string_literal: true

require "sym_differ/get_first_order_differential_equation_approximation_interactor"

Before do
  @params = {
    expression_text: "",
    undetermined_function_name: "", variable_name: "",
    initial_value_abscissa: "", initial_value_ordinate: ""
  }
  @response = nil
end

After do
  @response = nil
end

Given("the approximation is requested of the equation y' = {}") do |expression_text|
  @params[:expression_text] =
    (expression_text == "~empty~" ? "" : expression_text)
end

Given("the initial \\(t-var, y-var) coordinate of the approximation is \\({}, {})") do |abscissa, ordinate|
  @params[:initial_value_abscissa] = abscissa
  @params[:initial_value_ordinate] = ordinate
end

Given("the y-variable name of the approximation is set to {}") do |variable_name|
  @params[:undetermined_function_name] =
    (variable_name == "~empty~" ? "" : variable_name)
end

Given("the t-variable name of the approximation is set to {}") do |variable_name|
  @params[:variable_name] =
    (variable_name == "~empty~" ? "" : variable_name)
end

When("the approximation is requested") do
  expression_text = @params.fetch(:expression_text)
  undetermined_function_name = @params.fetch(:undetermined_function_name)
  variable_name = @params.fetch(:variable_name)

  initial_value_coordinates =
    [Float(@params.fetch(:initial_value_abscissa)), Float(@params.fetch(:initial_value_ordinate))]

  @response =
    SymDiffer::GetFirstOrderDifferentialEquationApproximationInteractor.new.approximate_solution(
      expression_text,
      undetermined_function_name,
      variable_name,
      initial_value_coordinates
    )
end

Then("some of the values of the approximation are:") do |docstring|
  expected_evaluation_points =
    docstring.split("\n").map { |pointstring| pointstring.split(",").map(&:to_f) }

  expected_evaluation_point_matchers =
    expected_evaluation_points.map { |point| an_object_having_attributes(abscissa: point[0], ordinate: point[1]) }

  expect(@response).to have_attributes(
    approximated_solution: a_collection_including(*expected_evaluation_point_matchers)
  )
end
