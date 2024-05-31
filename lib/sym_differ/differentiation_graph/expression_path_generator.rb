# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module DifferentiationGraph
    # Generates a list of expression "points", coordinates representing the values of the given expression.
    class ExpressionPathGenerator
      extend Forwardable

      def initialize(step_size, expression_evaluator, numerical_analysis_item_factory, discontinuities_detector)
        @step_size = step_size
        @expression_evaluator = expression_evaluator
        @numerical_analysis_item_factory = numerical_analysis_item_factory
        @discontinuities_detector = discontinuities_detector
      end

      def generate(expression, variable_name, step_range)
        @expression = expression
        @variable_name = variable_name
        build_expression_points_for_expression(step_range, create_expression_path([]))
      end

      private

      def build_expression_points_for_expression(step_range, expression_path)
        return expression_path unless first_element_of_range(step_range) <= second_element_of_range(step_range)

        evaluation_point_for_current_step = evaluation_point_for_current_step(step_range)
        discontinuous_point_for_current_step = discontinuity_points_for_current_range(step_range)

        new_step_range = build_next_step_range(step_range)
        new_evaluation_points = [evaluation_point_for_current_step, discontinuous_point_for_current_step].compact

        new_expression_path = add_points_to_evaluation_path(expression_path, new_evaluation_points)

        build_expression_points_for_expression(new_step_range, new_expression_path)
      end

      def evaluation_point_for_current_step(step_range)
        step = step_range_minimum(step_range)
        value = evaluate_expression(step)
        create_evaluation_point(step, value)
      end

      def discontinuity_points_for_current_range(step_range)
        step_sized_range = build_step_sized_range(step_range)
        find_discontinuity(expression, variable_name, step_sized_range)
      end

      def build_next_step_range(step_range)
        new_minimum = step_range_minimum(step_range) + @step_size
        new_maximum = step_range_maximum(step_range)

        create_step_range((new_minimum..new_maximum))
      end

      def build_step_sized_range(step_range)
        new_minimum = step_range_minimum(step_range)
        new_maximum = step_range_minimum(step_range) + @step_size

        new_minimum..new_maximum
      end

      def add_points_to_evaluation_path(path, point)
        path.add_evaluation_points(point)
      end

      def evaluate_expression(step)
        @expression_evaluator.evaluate(expression, variable_name => step)
      end

      def first_element_of_range(step_range)
        step_range.first_element
      end

      def second_element_of_range(step_range)
        step_range.last_element
      end

      def step_range_minimum(step_range)
        step_range.minimum
      end

      def step_range_maximum(step_range)
        step_range.maximum
      end

      def_delegator :@discontinuities_detector, :find, :find_discontinuity

      def_delegators :@numerical_analysis_item_factory,
                     :create_step_range, :create_evaluation_point, :create_expression_path

      attr_reader :expression, :variable_name
    end
  end
end
