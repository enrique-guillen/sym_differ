# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/commands/build_sum_expression_command"
require "sym_differ/expression_text_language_compiler/tokens/operator_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Checkers
      # Checks the provided token and pushes a BuildSumExpressionCommand into the commands stack if applicable.
      class SumTokenChecker
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def check(token)
          return not_handled_response unless sum_token?(token)

          sum_expression_command = build_command_type_stack_item(build_sum_expression_command)
          handled_response(sum_expression_command)
        end

        private

        def not_handled_response
          { handled: false }
        end

        def handled_response(stack_item)
          { handled: true, expression_location: :leftmost_or_infix, stack_item: }
        end

        def build_command_type_stack_item(command)
          { item_type: :pending_command, precedence: 0, value: command }
        end

        def sum_token?(token)
          token.is_a?(Tokens::OperatorToken) && token.symbol == "+"
        end

        def build_sum_expression_command
          @build_sum_expression_command ||= Commands::BuildSumExpressionCommand.new(@expression_factory)
        end
      end
    end
  end
end
