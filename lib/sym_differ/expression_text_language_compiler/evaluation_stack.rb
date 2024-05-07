# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    # A stack with commands or expressions representing the expression tree for a given expression text.
    class EvaluationStack
      def initialize(stack = [])
        @stack = stack
      end

      attr_reader :stack

      def add_item(item)
        EvaluationStack.new(@stack + [item])
      end

      def last_item
        @stack.last
      end

      def peek_item(index)
        @stack[index] unless index.negative?
      end
    end
  end
end
