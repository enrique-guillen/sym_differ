# frozen_string_literal: true

require "sym_differ/negate_expression"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Builds a NegateExpression out of the provided arguments.
    class BuildNegateExpressionCommand
      def execute(arguments)
        negated_expression = arguments.first
        build_negate_expression(negated_expression)
      end

      private

      def build_negate_expression(negated_expression)
        NegateExpression.new(negated_expression)
      end
    end
  end
end
