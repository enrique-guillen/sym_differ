# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/commands/build_subtract_expression_command"
require "sym_differ/expression_text_language_compiler/tokens/operator_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module EvaluationStackItemifiers
      # Checks the provided token and pushes a BuildSubtractExpressionCommand into the commands stack if applicable.
      class SubtractionTokenItemifier
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def check(token)
          return not_handled_response unless subtraction_token?(token)

          command = build_subtract_expression_command
          subtract_expression_command = build_command_type_stack_item(2, 1, 2, command)
          handled_response(:post_subtraction_token_checkers, subtract_expression_command)
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
