# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/tokens/identifier_token"
require "sym_differ/expression_text_language_compiler/commands/build_identifier_expression_command"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Checkers
      # Checks the provided token and pushes a BuildVariableExpressionCommand into the commands stack if applicable.
      class IdentifierTokenChecker
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def check(token)
          return not_handled_response unless variable_token?(token)

          command_stack_item = build_command_type_stack_item(9, 0, 1, build_identifier_command(token))

          handled_response(command_stack_item)
        end

        private

        def not_handled_response
          { handled: false }
        end

        def handled_response(stack_item)
          { handled: true, expression_location: :rightmost, stack_item: }
        end

        def build_command_type_stack_item(precedence, min_argument_amount, max_argument_amount, command)
          { item_type: :pending_command,
            precedence:,
            min_argument_amount:,
            max_argument_amount:,
            value: command }
        end

        def variable_token?(token)
          token.is_a?(Tokens::IdentifierToken)
        end

        def build_identifier_command(token)
          SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildIdentifierExpressionCommand
            .new(@expression_factory, token.name)
        end
      end
    end
  end
end
