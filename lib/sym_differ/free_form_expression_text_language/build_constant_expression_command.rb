# frozen_string_literal: true

require "sym_differ/constant_expression"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Builds a VariableExpression out of the provided arguments.
    class BuildConstantExpressionCommand
      def execute(arguments)
        value = arguments.first
        build_constant_expression(value)
      end

      private

      def build_constant_expression(value)
        ConstantExpression.new(value)
      end
    end
  end
end
