# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/commands/build_sum_expression_command"
require "sym_differ/expression_text_language_compiler/tokens/operator_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module EvaluationStackItemifiers
      # Checks the provided token and pushes a BuildSumExpressionCommand into the commands stack if applicable.
      class SumTokenItemifier
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def check(token)
          return not_handled_response unless sum_token?(token)

          command = build_sum_expression_command
          sum_expression_command = build_command_type_stack_item(1, 1, 2, command)

          handled_response(:post_sum_token_checkers, sum_expression_command)
        end

        private

        def not_handled_response
          { handled: false }
        end

        def handled_response(next_expected_token_type, stack_item)
          { handled: true, next_expected_token_type:, stack_item: }
        end

        def build_command_type_stack_item(precedence, min_argument_amount, max_argument_amount, command)
          { item_type: :pending_command, precedence:, min_argument_amount:, max_argument_amount:, value: command }
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
