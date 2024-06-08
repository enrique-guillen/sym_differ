# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    module EvaluationStackItemifiers
      # Checks the provided token and pushes a special named constant expression stack item into the commands stack if
      # applicable.
      class SpecialConstantItemifier
        def initialize(expression_factory)
          @expression_factory = expression_factory
        end

        def check(token)
          return not_handled_response unless special_named_constant_token?(token)

          constant_expression = create_euler_number_expression
          constant_expression_stack_item = build_expression_type_stack_item(constant_expression)

          handled_response(:post_constant_token_checkers, constant_expression_stack_item)
        end

        private

        def not_handled_response
          { handled: false }
        end

        def handled_response(next_expected_token_type, stack_item)
          { handled: true, next_expected_token_type:, stack_item: }
        end

        def build_expression_type_stack_item(expression)
          { item_type: :expression, precedence: 1, value: expression }
        end

        def create_euler_number_expression
          @expression_factory.create_euler_number_expression
        end

        def special_named_constant_token?(token)
          token.is_a?(Tokens::SpecialNamedConstantToken) && token.text == "e"
        end
      end
    end
  end
end
