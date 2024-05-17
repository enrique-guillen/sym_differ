# frozen_string_literal: true

require "sym_differ/step_range"
require "sym_differ/evaluation_point"
require "forwardable"

module SymDiffer
  # Returns an expression path (list of approximate coordinates) that solve the equation f'=provided-expression.
  class RungeKuttaFourSolutionApproximator
    extend Forwardable

    def initialize(expression_evaluator, step_size)
      @expression_evaluator = expression_evaluator
      @step_size = step_size
    end

    def approximate_solution(equation_parameters, step_range)
      @equation_parameters = equation_parameters
      approximate_solution_for_step_range(step_range, [build_evaluation_point(*equation_initial_coordinates)])
    end

    private

    def approximate_solution_for_step_range(step_range, evaluation_path)
      return evaluation_path if no_remaining_items_in_range?(step_range)

      current_abscissa = step_range_minimum(step_range)
      next_value = calculate_next_value(evaluation_path, current_abscissa)
      next_evaluation_point = build_evaluation_point(current_abscissa, next_value)

      next_step_range = cut_front_of_step_range(step_range)
      next_evaluation_path = add_point_to_evaluation_path(evaluation_path, next_evaluation_point)

      approximate_solution_for_step_range(next_step_range, next_evaluation_path)
    end

    def no_remaining_items_in_range?(step_range)
      step_range_first_element(step_range) > step_range_last_element(step_range)
    end

    def calculate_next_value(evaluation_path, current_abscissa)
      previously_calculated_evaluation_point = last_point_of_evaluation_path(evaluation_path)
      base_y_function_value = access_ordinate_of_evaluation_point(previously_calculated_evaluation_point)

      sum_component_k_1 = k1_sum_component(base_y_function_value, current_abscissa) / 6.0
      sum_component_k_2 = k2_sum_component(base_y_function_value, sum_component_k_1, current_abscissa) / 3.0
      sum_component_k_3 = k3_sum_component(base_y_function_value, sum_component_k_2, current_abscissa) / 3.0
      sum_component_k_4 = k4_sum_component(base_y_function_value, sum_component_k_3, current_abscissa) / 6.0

      base_y_function_value + sum_component_k_1 + sum_component_k_2 + sum_component_k_3 + sum_component_k_4
    end

    def cut_front_of_step_range(step_range)
      new_minimum_value = step_range_minimum(step_range) + @step_size
      maximum_value = step_range_maximum(step_range)
      build_step_range(new_minimum_value..maximum_value)
    end

    def k1_sum_component(base_y_function_value, current_abscissa)
      expression_value_scaled_by_step_size(
        equation_expression, equation_variable_name => current_abscissa,
                             equation_undetermined_function_name => base_y_function_value
      )
    end

    def k2_sum_component(base_y_function_value, component_k_1, current_abscissa)
      expression_value_scaled_by_step_size(
        equation_expression, equation_variable_name => (current_abscissa + (@step_size / 2.0)),
                             equation_undetermined_function_name => (base_y_function_value + (component_k_1 / 2.0))
      )
    end

    def k3_sum_component(base_y_function_value, component_k_2, current_abscissa)
      expression_value_scaled_by_step_size(
        equation_expression, equation_variable_name => (current_abscissa + (@step_size / 2.0)),
                             equation_undetermined_function_name => (base_y_function_value + (component_k_2 / 2.0))
      )
    end

    def k4_sum_component(base_y_function_value, component_k_3, current_abscissa)
      expression_value_scaled_by_step_size(
        equation_expression, equation_variable_name => (current_abscissa + @step_size),
                             equation_undetermined_function_name => (base_y_function_value + component_k_3)
      )
    end

    def expression_value_scaled_by_step_size(expression, variables)
      scale_by_step_size(evaluate_expression(expression, variables))
    end

    def scale_by_step_size(value)
      @step_size * value
    end

    def evaluate_expression(expression, variable_values)
      @expression_evaluator.evaluate(expression, variable_values)
    end

    def add_point_to_evaluation_path(evaluation_path, point)
      evaluation_path + [point]
    end

    def last_point_of_evaluation_path(path)
      path.last
    end

    def access_ordinate_of_evaluation_point(point)
      point.ordinate
    end

    def build_evaluation_point(abscissa, ordinate)
      EvaluationPoint.new(abscissa, ordinate)
    end

    def step_range_minimum(step_range)
      step_range.minimum
    end

    def step_range_maximum(step_range)
      step_range.maximum
    end

    def step_range_first_element(step_range)
      step_range.first_element
    end

    def step_range_last_element(step_range)
      step_range.last_element
    end

    def build_step_range(range)
      StepRange.new(range)
    end

    %w[expression variable_name undetermined_function_name initial_coordinates]
      .each { |method_name| def_delegator :equation_parameters, method_name, "equation_#{method_name}" }

    attr_reader :equation_parameters
  end
end
