# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Commands
      # Builds a MultiplicateExpression out of the provided arguments.
      class BuildMultiplicateExpressionCommand
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def execute(arguments)
          multiplicand, multiplier = arguments
          create_multiplicate_expression(multiplicand, multiplier)
        end

        private

        def create_multiplicate_expression(multiplicand, multiplier)
          @expression_factory.create_multiplicate_expression(multiplicand, multiplier)
        end
      end
    end
  end
end
