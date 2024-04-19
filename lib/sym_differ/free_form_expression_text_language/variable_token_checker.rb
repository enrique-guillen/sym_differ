# frozen_string_literal: true

require "sym_differ/variable_expression"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Checks the provided token and pushes a BuildVariableExpressionCommand into the commands stack if applicable.
    class VariableTokenChecker
      def check(token)
        return not_handled_response unless variable_token?(token)

        variable_expression_stack_item = build_expression_type_stack_item(build_variable_expression_from_token(token))

        handled_response(variable_expression_stack_item)
      end

      private

      def not_handled_response
        { handled: false }
      end

      def handled_response(stack_item)
        { handled: true, expression_location: :rightmost, stack_item: }
      end

      def build_expression_type_stack_item(expression)
        { item_type: :expression, value: expression }
      end

      def variable_token?(token)
        token.is_a?(VariableToken)
      end

      def build_variable_expression_from_token(token)
        VariableExpression.new(token.name)
      end
    end
  end
end