# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    # A stack with commands or expressions representing the expression tree for a given expression text.
    class EvaluationStack
      def initialize(stack = [])
        @stack = stack
      end

      attr_reader :stack

      def add_item_to_stack(item)
        EvaluationStack.new(@stack + [item])
      end

      def last_item_in_stack
        @stack.last
      end
    end
  end
end
