# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/tokens/parens_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Checkers
      # Checks the provided token and pushes a precedence change into the commands stack if applicable.
      class ParensTokenChecker
        def check(token)
          return build_not_handled_response unless token.is_a?(Tokens::ParensToken)

          new_precedence_change = token.type == :opening ? 10 : -10

          stack_item = build_precedence_change_stack_item(new_precedence_change)

          new_next_expected_token_type = token.type == :opening ? :prefix_token_checkers : :infix_token_checkers

          build_handled_response(new_next_expected_token_type, stack_item)
        end

        private

        def build_not_handled_response
          { handled: false }
        end

        def build_handled_response(next_expected_token_type, stack_item)
          { handled: true, next_expected_token_type:, stack_item: }
        end

        def build_precedence_change_stack_item(new_precedence_change)
          build_stack_item(:precedence_change, new_precedence_change)
        end

        def build_stack_item(item_type, new_precedence_change)
          { item_type:, new_precedence_change: }
        end
      end
    end
  end
end
