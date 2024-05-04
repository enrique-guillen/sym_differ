# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Commands
      # Builds a VariableExpression for FunctionCallExpression out of the provided arguments.
      class BuildIdentifierExpressionCommand
        def initialize(expression_factory, identifier_name)
          @expression_factory = expression_factory
          @identifier_name = identifier_name
        end

        def execute(arguments)
          return create_variable_expression(@identifier_name) if arguments.empty?

          angle_expression = arguments[0]
          create_sine_expression(angle_expression)
        end

        private

        def create_variable_expression(name)
          @expression_factory.create_variable_expression(name)
        end

        def create_sine_expression(angle_expression)
          @expression_factory.create_sine_expression(angle_expression)
        end
      end
    end
  end
end
