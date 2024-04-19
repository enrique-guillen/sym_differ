# frozen_string_literal: true

require "sym_differ/free_form_expression_text_language/build_sum_expression_command"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Checks the provided token and pushes a BuildSumExpressionCommand into the commands stack if applicable.
    class SumTokenChecker
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
        { item_type: :pending_command, value: command }
      end

      def sum_token?(token)
        token.is_a?(OperatorToken) && token.symbol == "+"
      end

      def build_sum_expression_command
        @build_sum_expression_command ||= BuildSumExpressionCommand.new
      end

      def operator_token?(token)
        token.is_a?(OperatorToken)
      end

      def token_symbol_is_plus?(token)
        token.symbol == "-"
      end
    end
  end
end
