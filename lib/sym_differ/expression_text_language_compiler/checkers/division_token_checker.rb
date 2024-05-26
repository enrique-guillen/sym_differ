# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Checkers
      # Checks the provided token and pushes a BuildDivideExpressionCommand into the commands stack if applicable.
      class DivisionTokenChecker
        def check(token)
          return build_not_handled_response unless division_token?(token)

          command = build_divide_expression_command
          stack_item = build_command_type_stack_item(4, 2, 2, command)

          build_handled_response(:post_division_token_checkers, stack_item)
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

        def division_token?(token)
          token.is_a?(Tokens::OperatorToken) && token.symbol == "/"
        end

        def build_divide_expression_command
          Commands::BuildDivideExpressionCommand.new(@expression_factory)
        end
      end
    end
  end
end
