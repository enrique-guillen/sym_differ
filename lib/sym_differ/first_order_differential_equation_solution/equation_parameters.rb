# frozen_string_literal: true

module SymDiffer
  module FirstOrderDifferentialEquationSolution
    # Parameters of a first-order differential equation to approximate or solve.
    class EquationParameters
      def initialize(expression, y_variable_name, t_variable_name, initial_coordinates)
        @expression = expression
        @undetermined_function_name = y_variable_name
        @variable_name = t_variable_name
        @initial_coordinates = initial_coordinates
      end

      attr_reader :expression, :undetermined_function_name, :variable_name, :initial_coordinates
    end
  end
end
