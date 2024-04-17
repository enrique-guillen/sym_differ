# frozen_string_literal: true

require "sym_differ/variable_expression"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Builds a VariableExpression out of the provided arguments.
    class BuildVariableExpressionCommand
      def execute(arguments)
        name = arguments.first
        build_variable_expression(name)
      end

      private

      def build_variable_expression(name)
        VariableExpression.new(name)
      end
    end
  end
end
