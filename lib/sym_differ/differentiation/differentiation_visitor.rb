# frozen_string_literal: true

require "sym_differ/differentiation/constant_expression_deriver"

module SymDiffer
  module Differentiation
    # Performs the appropriate differentiation operation on each element of the Expression hierarchy.
    class DifferentiationVisitor
      def visit_constant_expression(constant_expression)
        ConstantExpressionDeriver.new.derive(constant_expression)
      end
    end
  end
end