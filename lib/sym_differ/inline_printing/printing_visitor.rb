# frozen_string_literal: true

module SymDiffer
  module InlinePrinting
    # Methods for displaying all the elements of an expression into a single inline string.
    class PrintingVisitor
      def visit_constant_expression(expression)
        expression.value.to_s
      end

      def visit_variable_expression(expression)
        expression.name
      end

      def visit_negate_expression(expression)
        "-#{expression.negated_expression.accept(self)}"
      end

      def visit_sum_expression(expression)
        "#{expression.expression_a.accept(self)} + #{expression.expression_b.accept(self)}"
      end
    end
  end
end
