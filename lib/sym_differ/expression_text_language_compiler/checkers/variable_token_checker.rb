# frozen_string_literal: true

require "sym_differ/expressions/variable_expression"
require "sym_differ/expression_text_language_compiler/tokens/identifier_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Checkers
      # Checks the provided token and pushes a BuildVariableExpressionCommand into the commands stack if applicable.
      class VariableTokenChecker
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def check(token)
          return not_handled_response unless variable_token?(token)

          variable_expression_stack_item = build_expression_type_stack_item(build_variable_expression_from_token(token))

          handled_response(variable_expression_stack_item)
        end

        private

        def not_handled_response
          { handled: false }
        end

        def handled_response(stack_item)
          { handled: true, expression_location: :rightmost, stack_item: }
        end

        def build_expression_type_stack_item(expression)
          { item_type: :expression, precedence: 1, value: expression }
        end

        def variable_token?(token)
          token.is_a?(Tokens::IdentifierToken)
        end

        def build_variable_expression_from_token(token)
          @expression_factory.create_variable_expression(token.name)
        end
      end
    end
  end
end
