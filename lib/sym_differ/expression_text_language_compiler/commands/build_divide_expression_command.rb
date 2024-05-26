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
          SymDiffer::Expressions::DivideExpression.new(numerator, denominator)
        end
      end
    end
  end
end
