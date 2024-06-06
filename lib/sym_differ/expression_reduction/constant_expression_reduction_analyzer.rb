# frozen_string_literal: true

module SymDiffer
  module ExpressionReduction
    # Generates an analysis of how the constant expression can re-expressed for reduction purposes, after removing the
    # superfluous terms and putting it into canonical form.
    class ConstantExpressionReductionAnalyzer
      def reduce_expression(expression)
        expression
      end

      def make_sum_partition(expression)
        sum_partition(expression.value, nil)
      end

      def make_factor_partition(expression)
        factor_partition(expression.value, nil)
      end

      private

      def sum_partition(constant, subexpression)
        [constant, subexpression]
      end

      def factor_partition(constant, subexpression)
        [constant, subexpression]
      end
    end
  end
end
