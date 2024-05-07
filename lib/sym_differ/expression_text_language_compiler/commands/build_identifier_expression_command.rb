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

          nested_expression = arguments[0]

          case @identifier_name
          when "sine"
            create_sine_expression(nested_expression)
          when "cosine"
            create_cosine_expression(nested_expression)
          end
        end

        attr_reader :identifier_name

        private

        def create_variable_expression(name)
          @expression_factory.create_variable_expression(name)
        end

        def create_sine_expression(angle_expression)
          @expression_factory.create_sine_expression(angle_expression)
        end

        def create_cosine_expression(angle_expression)
          @expression_factory.create_cosine_expression(angle_expression)
        end
      end
    end
  end
end
