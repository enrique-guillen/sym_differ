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
        evaluation_stack(@stack + [item])
      end

      def last_item
        @stack.last
      end

      def peek_item(index)
        @stack[index] unless index.negative?
      end

      def extract_beginning_partition(size)
        new_stack = @stack[0, size].to_a
        evaluation_stack(new_stack)
      end

      def extract_tail_end_partition(starting_index)
        new_stack = @stack[starting_index, @stack.size].to_a
        evaluation_stack(new_stack)
      end

      def extract_stack_partition(starting_index, size)
        new_stack = @stack[starting_index, size].to_a
        evaluation_stack(new_stack)
      end

      def combine(other_stack)
        new_stack = @stack + other_stack.stack
        evaluation_stack(new_stack)
      end

      private

      def evaluation_stack(stack)
        EvaluationStack.new(stack)
      end
    end
  end
end
