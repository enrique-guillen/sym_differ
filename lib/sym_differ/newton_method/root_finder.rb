# frozen_string_literal: true

require "sym_differ/newton_method/expression_transform_evaluator"

module SymDiffer
  module NewtonMethod
    # Finds a variable value for which the given expression yields a value close to 0.0, by implementing the Newton
    # Method's steps.
    class RootFinder
      def initialize(derivative_slope_width, expression_evaluator, fixed_point_finder_creator)
        @derivative_slope_width = derivative_slope_width
        @expression_evaluator = expression_evaluator
        @fixed_point_finder_creator = fixed_point_finder_creator
      end

      def find(expression, variable, first_guess)
        expression_newton_transform_evaluator =
          create_expression_newton_transform_evaluator(variable)

        fixed_point_finder =
          create_fixed_point_finder(expression_newton_transform_evaluator)

        fixed_point_finder.approximate(expression, variable, first_guess)
      end

      private

      def create_expression_newton_transform_evaluator(variable)
        NewtonMethod::ExpressionTransformEvaluator
          .new(@derivative_slope_width, variable, @expression_evaluator)
      end

      def create_fixed_point_finder(expression_evaluator)
        @fixed_point_finder_creator.create(expression_evaluator)
      end
    end
  end
end
