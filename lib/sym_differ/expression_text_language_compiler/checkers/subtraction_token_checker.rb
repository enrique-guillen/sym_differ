# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/commands/build_subtract_expression_command"
require "sym_differ/expression_text_language_compiler/tokens/operator_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Checkers
      # Checks the provided token and pushes a BuildSubtractExpressionCommand into the commands stack if applicable.
      class SubtractionTokenChecker
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def check(token)
          return not_handled_response unless subtraction_token?(token)

          subtract_expression_command = build_command_type_stack_item(build_subtract_expression_command)
          handled_response(subtract_expression_command)
        end

        private

        def not_handled_response
          { handled: false }
        end

        def handled_response(stack_item)
          { handled: true, expression_location: :leftmost_or_infix, stack_item: }
        end

        def build_command_type_stack_item(command)
          { item_type: :pending_command, precedence: 1, value: command }
        end

        def subtraction_token?(token)
          operator_token?(token) && token_symbol_is_dash?(token)
        end

        def build_subtract_expression_command
          @build_subtract_expression_command ||= Commands::BuildSubtractExpressionCommand.new(@expression_factory)
        end

        def operator_token?(token)
          token.is_a?(Tokens::OperatorToken)
        end

        def token_symbol_is_dash?(token)
          token.symbol == "-"
        end
      end
    end
  end
end
