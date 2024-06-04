# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents the special Euler number constant with decimal expansion ~2.718281828459045.
    class EulerNumberExpression
      def accept(visitor, *, &)
        visitor.visit_euler_number_expression(self, *, &)
      end

      def same_as?(other_expression)
        other_expression.is_a?(EulerNumberExpression)
      end
    end
  end
end
