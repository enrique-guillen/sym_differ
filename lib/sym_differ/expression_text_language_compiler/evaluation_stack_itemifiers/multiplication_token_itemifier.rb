# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/commands/build_multiplicate_expression_command"
require "sym_differ/expression_text_language_compiler/tokens/operator_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module EvaluationStackItemifiers
      # Checks the provided token and pushes a BuildMultiplicateExpressionCommand into the commands stack if applicable.
      class MultiplicationTokenItemifier
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def check(token)
          return build_not_handled_response unless multiplicate_token?(token)

          multiplicate_expression_command = build_multiplicate_expression_command

          multiplicate_expression_command_stack_item =
            build_command_type_stack_item(3, 2, 2, multiplicate_expression_command)

          build_handled_response(:post_multiplication_token_checkers, multiplicate_expression_command_stack_item)
        end

        private

        def build_not_handled_response
          { handled: false }
        end

        def build_handled_response(next_expected_token_type, stack_item)
          { handled: true, next_expected_token_type:, stack_item: }
        end

        def build_command_type_stack_item(precedence, min_argument_amount, max_argument_amount, value)
          { item_type: :pending_command, precedence:, min_argument_amount:, max_argument_amount:, value: }
        end

        def multiplicate_token?(token)
          token.is_a?(Tokens::OperatorToken) && token.symbol == "*"
        end

        def build_multiplicate_expression_command
          Commands::BuildMultiplicateExpressionCommand.new(@expression_factory)
        end
      end
    end
  end
end
