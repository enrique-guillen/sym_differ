# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/tokens/constant_token"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Checks the provided token and pushes a BuildConstantExpressionCommand into the commands stack if applicable.
    class ConstantTokenChecker
      def initialize(expression_factory)
        @expression_factory = expression_factory
      end

      def check(token)
        return not_handled_response unless constant_token?(token)

        constant_expression_stack_item = build_expression_type_stack_item(build_constant_expression_from_token(token))
        handled_response(constant_expression_stack_item)
      end

      private

      def not_handled_response
        { handled: false }
      end

      def handled_response(stack_item)
        { handled: true, expression_location: :rightmost, stack_item: }
      end

      def build_expression_type_stack_item(expression)
        { item_type: :expression, precedence: 1, value: expression }
      end

      def build_constant_expression_from_token(token)
        @expression_factory.create_constant_expression(token.value)
      end

      def constant_token?(token)
        token.is_a?(Tokens::ConstantToken)
      end
    end
  end
end
