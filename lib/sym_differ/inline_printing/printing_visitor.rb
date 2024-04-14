# frozen_string_literal: true

module SymDiffer
  module InlinePrinting
    # Methods for displaying all the elements of an expression into a single inline string.
    class PrintingVisitor
      def initialize(parenthesize_subtraction_expressions: false)
        @parenthesize_subtraction_expressions = parenthesize_subtraction_expressions
      end

      attr_reader :parenthesize_subtraction_expressions

      def visit_constant_expression(expression)
        expression.value.to_s
      end

      def visit_variable_expression(expression)
        expression.name
      end

      def visit_negate_expression(expression)
        stringified_negated_expression = stringify_expression(expression.negated_expression)

        prefix_with_dash(stringified_negated_expression)
      end

      def visit_sum_expression(expression)
        stringified_expression_a = stringify_expression(expression.expression_a)
        stringified_expression_b = stringify_expression(expression.expression_b)

        join_with_plus_sign(stringified_expression_a, stringified_expression_b)
      end

      def visit_subtract_expression(expression)
        nested_visitor = build_visitor(parenthesize_subtraction_expressions: true)

        stringified_minuend = stringify_expression(expression.minuend)
        stringified_subtrahend = stringify_expression(expression.subtrahend, visitor: nested_visitor)
        result = join_with_dash(stringified_minuend, stringified_subtrahend)

        @parenthesize_subtraction_expressions ? surround_in_parenthesis(result) : result
      end

      private

      def prefix_with_dash(expression)
        "-#{expression}"
      end

      def join_with_plus_sign(expression_a, expression_b)
        "#{expression_a} + #{expression_b}"
      end

      def join_with_dash(expression_a, expression_b)
        "#{expression_a} - #{expression_b}"
      end

      def surround_in_parenthesis(expression)
        "(#{expression})"
      end

      def stringify_expression(expression, visitor: self)
        expression.accept(visitor)
      end

      def build_visitor(parenthesize_subtraction_expressions: true)
        self.class.new(parenthesize_subtraction_expressions:)
      end
    end
  end
end
