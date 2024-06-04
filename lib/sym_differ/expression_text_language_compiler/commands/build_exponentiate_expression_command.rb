# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Commands
      # Builds a ExponentiateExpression out of the provided arguments.
      class BuildExponentiateExpressionCommand
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def execute(arguments)
          base, power = arguments
          create_exponentiate_expression(base, power)
        end

        private

        def create_exponentiate_expression(*)
          @expression_factory.create_exponentiate_expression(*)
        end
      end
    end
  end
end
