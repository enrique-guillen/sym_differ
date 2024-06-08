# frozen_string_literal: true

require "forwardable"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Commands
      # Builds a VariableExpression for FunctionCallExpression out of the provided arguments.
      class BuildIdentifierExpressionCommand
        extend Forwardable

        def initialize(expression_factory, identifier_name)
          @expression_factory = expression_factory
          @identifier_name = identifier_name
        end

        def execute(arguments)
          return create_variable_expression(@identifier_name) if arguments.empty?

          build_arity_one_function_expression(arguments.first)
        end

        attr_reader :identifier_name

        private

        def build_arity_one_function_expression(nested_expression)
          case @identifier_name
          when "sine"
            create_sine_expression(nested_expression)
          when "cosine"
            create_cosine_expression(nested_expression)
          when "ln"
            create_natural_logarithm_expression(nested_expression)
          end
        end

        def_delegators :@expression_factory,
                       :create_variable_expression,
                       :create_sine_expression,
                       :create_cosine_expression,
                       :create_natural_logarithm_expression
      end
    end
  end
end
