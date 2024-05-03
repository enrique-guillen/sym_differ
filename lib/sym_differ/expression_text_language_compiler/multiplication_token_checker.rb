# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/commands/build_multiplicate_expression_command"
require "sym_differ/expression_text_language_compiler/tokens/operator_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Checks the provided token and pushes a BuildMultiplicateExpressionCommand into the commands stack if applicable.
    class MultiplicationTokenChecker
      def initialize(expression_factory)
        @expression_factory = expression_factory
      end

      def check(token)
        return build_not_handled_response unless multiplicate_token?(token)

        multiplicate_expression_command = build_command_type_stack_item(
          build_multiplicate_expression_command
        )

        build_handled_response(:infix, multiplicate_expression_command)
      end

      private

      def build_not_handled_response
        { handled: false }
      end

      def build_handled_response(expression_location, stack_item)
        { handled: true, expression_location:, stack_item: }
      end

      def build_command_type_stack_item(value)
        { item_type: :pending_command, precedence: 2, value: }
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
