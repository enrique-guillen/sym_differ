# frozen_string_literal: true

require "sym_differ/expression_reduction/constant_expression_reduction_analyzer"
require "sym_differ/expression_reduction/variable_expression_reduction_analyzer"

module SymDiffer
  module ExpressionReduction
    # Provides a way to split the given expression into a product of terms, and exposes methods for each expression tree
    # type of expression as well.
    class FactorPartitionerVisitor
      def partition(expression)
        expression.accept(self)
      end

      def visit_constant_expression(expression)
        ConstantExpressionReductionAnalyzer
          .new
          .make_factor_partition(expression)
      end

      def visit_variable_expression(expression)
        VariableExpressionReductionAnalyzer
          .new
          .make_factor_partition(expression)
      end
    end
  end
end
