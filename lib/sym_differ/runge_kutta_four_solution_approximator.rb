# frozen_string_literal: true

require "sym_differ/differentiation_graph/step_range"

module SymDiffer
  # Returns an expression path (list of approximate coordinates) that solve the equation f'=provided-expression.
  class RungeKuttaFourSolutionApproximator
    def initialize(expression_evaluator, step_size)
      @expression_evaluator = expression_evaluator
      @step_size = step_size
    end

    def approximate_solution(
      expression,
      y_variable_name,
      t_variable_name,
      initial_coordinates,
      step_range,
      evaluation_path = [initial_coordinates]
    )
      return evaluation_path if no_remaining_items_in_range?(step_range)

      next_value = calculate_next_value(
        expression, t_variable_name, y_variable_name, step_range, evaluation_path, initial_coordinates
      )

      next_evaluation_point = build_evaluation_point(step_range.minimum, next_value)

      next_step_range = build_step_range((step_range.minimum + @step_size)..(step_range.maximum))
      next_evaluation_path = add_point_to_evaluation_path(evaluation_path, next_evaluation_point)

      approximate_solution(
        expression, y_variable_name, t_variable_name, initial_coordinates, next_step_range, next_evaluation_path
      )
    end

    private

    def no_remaining_items_in_range?(step_range)
      step_range.first_element > step_range.last_element
    end

    def calculate_next_value(
      expression, t_variable_name, y_variable_name, step_range, evaluation_path, initial_coordinates
    )
      base_y_function_value = (evaluation_path.last || initial_coordinates)[1]

      sum_component_k_1 =
        k1_sum_component(expression, t_variable_name, y_variable_name, base_y_function_value, step_range)

      sum_component_k_2 = k2_sum_component(expression, t_variable_name, y_variable_name,
                                           base_y_function_value, sum_component_k_1, step_range)

      sum_component_k_3 = k3_sum_component(expression, t_variable_name, y_variable_name,
                                           base_y_function_value, sum_component_k_2, step_range)

      sum_component_k_4 = k4_sum_component(expression, t_variable_name, y_variable_name,
                                           base_y_function_value, sum_component_k_3, step_range)

      base_y_function_value + sum_component_k_1 + sum_component_k_2 + sum_component_k_3 + sum_component_k_4
    end

    def k1_sum_component(expression, t_variable_name, y_variable_name, base_y_function_value, step_range)
      t_variable_value = step_range.minimum

      component_value =
        expression_value_scaled_by_step_size(
          expression, t_variable_name => t_variable_value,
                      y_variable_name => base_y_function_value
        )

      component_value / 6.0
    end

    def k2_sum_component(expression, t_variable_name, y_variable_name, base_y_function_value, component_k_1, step_range)
      t_variable_value = step_range.minimum + (@step_size / 2.0)
      y_variable_value = base_y_function_value + (component_k_1 / 2.0)

      component_value =
        expression_value_scaled_by_step_size(
          expression, t_variable_name => t_variable_value,
                      y_variable_name => y_variable_value
        )

      component_value / 3.0
    end

    def k3_sum_component(expression, t_variable_name, y_variable_name, base_y_function_value, component_k_2, step_range)
      t_variable_value = step_range.minimum + (@step_size / 2.0)
      y_variable_value = base_y_function_value + (component_k_2 / 2.0)

      component_value =
        expression_value_scaled_by_step_size(
          expression, t_variable_name => t_variable_value,
                      y_variable_name => y_variable_value
        )

      component_value / 3.0
    end

    def k4_sum_component(expression, t_variable_name, y_variable_name, base_y_function_value, component_k_3, step_range)
      t_variable_value = step_range.minimum + @step_size
      y_variable_value = base_y_function_value + component_k_3

      component_value =
        expression_value_scaled_by_step_size(
          expression, t_variable_name => t_variable_value,
                      y_variable_name => y_variable_value
        )

      component_value / 6.0
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

    def build_evaluation_point(abscissa, ordinate)
      [abscissa, ordinate]
    end

    def build_step_range(range)
      DifferentiationGraph::StepRange.new(range)
    end
  end
end
