# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/commands/build_exponentiate_expression_command"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Checkers
      # Checks the provided token and pushes a BuildExponentiateExpressionCommand into the commands stack if applicable.
      class ExponentiationTokenChecker
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def check(token)
          return build_not_handled_response unless exponentiation_token?(token)

          command = build_command

          stack_item = build_command_type_stack_item(5, 2, 2, command)

          build_handled_response(:post_exponentiation_token_checkers, stack_item)
        end

        private

        def build_command
          Commands::BuildExponentiateExpressionCommand.new(@expression_factory)
        end

        def build_not_handled_response
          { handled: false }
        end

        def build_handled_response(next_expected_token_type, stack_item)
          { handled: true, next_expected_token_type:, stack_item: }
        end

        def build_command_type_stack_item(precedence, min_argument_amount, max_argument_amount, value)
          { item_type: :pending_command, precedence:, min_argument_amount:, max_argument_amount:, value: }
        end

        def exponentiation_token?(token)
          token.is_a?(Tokens::OperatorToken) && token.symbol == "^"
        end
      end
    end
  end
end
