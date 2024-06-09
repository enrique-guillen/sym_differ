# frozen_string_literal: true

require "sym_differ/expression_text_language_compiler/unrecognized_special_named_constant_error"

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

          constant_expression = create_special_named_constant_expression(token)
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

        def create_special_named_constant_expression(token)
          case token.text
          when "e"
            create_euler_number_expression
          else
            raise_unrecognized_special_constant_name_error
          end
        end

        def create_euler_number_expression
          @expression_factory.create_euler_number_expression
        end

        def raise_unrecognized_special_constant_name_error
          raise UnrecognizedSpecialNamedConstantError.new
        end

        def special_named_constant_token?(token)
          token.is_a?(Tokens::SpecialNamedConstantToken)
        end
      end
    end
  end
end
