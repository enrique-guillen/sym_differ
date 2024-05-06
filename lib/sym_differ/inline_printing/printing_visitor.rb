# frozen_string_literal: true

module SymDiffer
  module InlinePrinting
    # Methods for displaying all the elements of an expression into a single inline string.
    class PrintingVisitor
      def initialize(parenthesize_infix_expressions_once: false)
        @parenthesize_infix_expressions_once = parenthesize_infix_expressions_once
      end

      attr_reader :parenthesize_infix_expressions_once

      def visit_constant_expression(expression)
        expression.value.to_s
      end

      def visit_variable_expression(expression)
        expression.name
      end

      def visit_negate_expression(expression)
        nested_visitor = build_visitor(parenthesize_infix_expressions_once: true)

        stringified_negated_expression = stringify_expression(expression.negated_expression, visitor: nested_visitor)

        prefix_with_dash(stringified_negated_expression)
      end

      def visit_sum_expression(expression)
        nested_visitor =
          should_parenthesize_infix_expression? ? build_visitor(parenthesize_infix_expressions_once: false) : self

        stringified_expression_a = stringify_expression(expression.expression_a, visitor: nested_visitor)
        stringified_expression_b = stringify_expression(expression.expression_b, visitor: nested_visitor)
        result = join_with_plus_sign(stringified_expression_a, stringified_expression_b)

        (result = surround_in_parenthesis(result)) if should_parenthesize_infix_expression?

        result
      end

      def visit_subtract_expression(expression)
        minuend_visitor =
          should_parenthesize_infix_expression? ? build_visitor(parenthesize_infix_expressions_once: false) : self

        subtrahend_visitor = build_visitor(parenthesize_infix_expressions_once: true)

        stringified_minuend = stringify_expression(expression.minuend, visitor: minuend_visitor)
        stringified_subtrahend = stringify_expression(expression.subtrahend, visitor: subtrahend_visitor)
        result = join_with_dash(stringified_minuend, stringified_subtrahend)

        (result = surround_in_parenthesis(result)) if should_parenthesize_infix_expression?

        result
      end

      def visit_multiplicate_expression(expression)
        nested_visitor = build_visitor(parenthesize_infix_expressions_once: true)

        stringified_multiplicand = stringify_expression(expression.multiplicand, visitor: nested_visitor)
        stringified_multiplier = stringify_expression(expression.multiplier, visitor: nested_visitor)

        join_with_asterisk(stringified_multiplicand, stringified_multiplier)
      end

      def visit_derivative_expression(expression)
        stringified_underived_expression = stringify_expression(expression.underived_expression)
        stringified_variable_expression = stringify_expression(expression.variable)

        join_function_name_and_arguments(
          "derivative", join_with_commas(stringified_underived_expression, stringified_variable_expression)
        )
      end

      def visit_sine_expression(expression)
        join_function_name_and_arguments("sine", stringify_expression(expression.angle_expression))
      end

      def visit_cosine_expression(expression)
        join_function_name_and_arguments("cosine", stringify_expression(expression.angle_expression))
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

      def join_with_asterisk(expression_a, expression_b)
        "#{expression_a} * #{expression_b}"
      end

      def join_function_name_and_arguments(function_name, arguments)
        "#{function_name}(#{arguments})"
      end

      def join_with_commas(*argument_list)
        argument_list.join(", ")
      end

      def stringify_expression(expression, visitor: self)
        expression.accept(visitor)
      end

      def should_parenthesize_infix_expression?
        @parenthesize_infix_expressions_once
      end

      def build_visitor(parenthesize_infix_expressions_once: false)
        self.class.new(parenthesize_infix_expressions_once:)
      end
    end
  end
end
