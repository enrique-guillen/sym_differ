# frozen_string_literal: true

module SymDiffer
  module Differentiation
    # Performs the appropriate differentiation operation on each element of the Expression hierarchy.
    class DifferentiationVisitor
      def visit_constant_expression(constant_expression)
        DeriveConstantExpression.new.derive(constant_expression)
      end
    end
  end
end
