# frozen_string_literal: true

require "sym_differ/expressions/subtract_expression"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Commands
      # Builds a SubtractExpression out of the provided arguments.
      class BuildSubtractExpressionCommand
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def execute(arguments)
          if arguments.size == 1
            negated_expression = arguments.first
            build_negate_expression(negated_expression)
          else
            minuend, subtrahend = arguments
            build_subtract_expression(minuend, subtrahend)
          end
        end

        private

        def build_subtract_expression(minuend, subtrahend)
          @expression_factory.create_subtract_expression(minuend, subtrahend)
        end

        def build_negate_expression(negated_expression)
          @expression_factory.create_negate_expression(negated_expression)
        end
      end
    end
  end
end
