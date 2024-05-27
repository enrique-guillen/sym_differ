# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Commands
      # Builds a DivideExpression out of the provided arguments.
      class BuildDivideExpressionCommand
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def execute(arguments)
          numerator, denominator = arguments
          create_divide_expression(numerator, denominator)
        end

        private

        def create_divide_expression(*)
          @expression_factory.create_divide_expression(*)
        end
      end
    end
  end
end
