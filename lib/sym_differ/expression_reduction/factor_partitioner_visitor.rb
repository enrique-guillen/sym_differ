# frozen_string_literal: true

require "sym_differ/expression_reduction/constant_expression_reduction_analyzer"
require "sym_differ/expression_reduction/variable_expression_reduction_analyzer"
require "sym_differ/expression_reduction/positive_expression_reduction_analyzer"
require "sym_differ/expression_reduction/negative_expression_reduction_analyzer"
require "sym_differ/expression_reduction/sum_expression_reduction_analyzer"
require "sym_differ/expression_reduction/subtract_expression_reduction_analyzer"
require "sym_differ/expression_reduction/multiplicate_expression_reduction_analyzer"
require "sym_differ/expression_reduction/divide_expression_reduction_analyzer"
require "sym_differ/expression_reduction/exponentiate_expression_reduction_analyzer"

module SymDiffer
  module ExpressionReduction
    # Provides a way to split the given expression into a product of terms, and exposes methods for each expression tree
    # type of expression as well.
    class FactorPartitionerVisitor
      def initialize(expression_factory, sum_partitioner)
        @expression_factory = expression_factory
        @sum_partitioner = sum_partitioner
      end

      attr_writer :expression_reducer

      def partition(expression)
        expression.accept(self)
      end

      def visit_constant_expression(expression)
        make_factor_partition(constant_expression_reduction_analyzer, expression)
      end

      def visit_variable_expression(expression)
        make_factor_partition(variable_expression_reduction_analyzer, expression)
      end

      def visit_positive_expression(expression)
        make_factor_partition(positive_expression_reduction_analyzer, expression)
      end

      def visit_negate_expression(expression)
        make_factor_partition(negative_expression_reduction_analyzer, expression)
      end

      def visit_sum_expression(expression)
        make_factor_partition(sum_expression_reduction_analyzer, expression)
      end

      def visit_subtract_expression(expression)
        make_factor_partition(subtract_expression_reduction_analyzer, expression)
      end

      def visit_multiplicate_expression(expression)
        make_factor_partition(multiplicate_expression_reduction_analyzer, expression)
      end

      def visit_divide_expression(expression)
        make_factor_partition(divide_expression_reduction_analyzer, expression)
      end

      def visit_exponentiate_expression(expression)
        make_factor_partition(exponentiate_expression_reduction_analyzer, expression)
      end

      private

      def constant_expression_reduction_analyzer
        @constant_expression_reduction_analyzer ||= ConstantExpressionReductionAnalyzer.new
      end

      def variable_expression_reduction_analyzer
        @variable_expression_reduction_analyzer ||= VariableExpressionReductionAnalyzer.new
      end

      def positive_expression_reduction_analyzer
        @positive_expression_reduction_analyzer ||=
          PositiveExpressionReductionAnalyzer
          .new(@expression_reducer, @sum_partitioner, self)
      end

      def negative_expression_reduction_analyzer
        @negative_expression_reduction_analyzer ||=
          NegativeExpressionReductionAnalyzer
          .new(@expression_reducer, @sum_partitioner, self)
      end

      def sum_expression_reduction_analyzer
        @sum_expression_reduction_analyzer ||=
          SumExpressionReductionAnalyzer
          .new(@expression_factory, @sum_partitioner, self)
      end

      def subtract_expression_reduction_analyzer
        @subtract_expression_reduction_analyzer ||=
          SubtractExpressionReductionAnalyzer
          .new(@expression_factory, @sum_partitioner, self)
      end

      def multiplicate_expression_reduction_analyzer
        @multiplicate_expression_reduction_analyzer ||=
          MultiplicateExpressionReductionAnalyzer
          .new(@expression_factory, @sum_partitioner, self)
      end

      def divide_expression_reduction_analyzer
        @divide_expression_reduction_analyzer ||=
          DivideExpressionReductionAnalyzer
          .new(@expression_factory, @expression_reducer)
      end

      def exponentiate_expression_reduction_analyzer
        @exponentiate_expression_reduction_analyzer ||=
          ExponentiateExpressionReductionAnalyzer
          .new(@expression_factory, @expression_reducer)
      end

      def make_factor_partition(reduction_analyzer, expression)
        reduction_analyzer.make_factor_partition(expression)
      end
    end
  end
end
