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
require "sym_differ/expression_reduction/natural_logarithm_expression_reduction_analyzer"

module SymDiffer
  module ExpressionReduction
    # Provides a way to remove superfluous terms from a given expression and exposes methods for each expression tree
    # type of expression as well.
    class ReducerVisitor
      def initialize(expression_factory, sum_partitioner_visitor, factor_partitioner_visitor)
        @expression_factory = expression_factory
        @sum_partitioner_visitor = sum_partitioner_visitor
        @factor_partitioner_visitor = factor_partitioner_visitor
      end

      def reduce(expression)
        expression.accept(self)
      end

      def visit_constant_expression(expression)
        perform_reduction(constant_expression_reduction_analyzer, expression)
      end

      def visit_variable_expression(expression)
        perform_reduction(variable_expression_reduction_analyzer, expression)
      end

      def visit_positive_expression(expression)
        perform_reduction(positive_expression_reduction_analyzer, expression)
      end

      def visit_negate_expression(expression)
        perform_reduction(negative_expression_reduction_analyzer, expression)
      end

      def visit_sum_expression(expression)
        perform_reduction(sum_expression_reduction_analyzer, expression)
      end

      def visit_subtract_expression(expression)
        perform_reduction(subtract_expression_reduction_analyzer, expression)
      end

      def visit_multiplicate_expression(expression)
        perform_reduction(multiplicate_expression_reduction_analyzer, expression)
      end

      def visit_divide_expression(expression)
        perform_reduction(divide_expression_reduction_analyzer, expression)
      end

      def visit_exponentiate_expression(expression)
        perform_reduction(exponentiate_expression_reduction_analyzer, expression)
      end

      def visit_natural_logarithm_expression(expression)
        perform_reduction(natural_logarithm_expression_reduction_analyzer, expression)
      end

      def default_visit_result(expression)
        expression
      end

      %i[sine cosine derivative euler_number].each do |expression_type|
        alias_method :"visit_#{expression_type}_expression", :default_visit_result
      end

      private

      def perform_reduction(reduction_analyzer, expression)
        reduction_analyzer.reduce_expression(expression)
      end

      def variable_expression_reduction_analyzer
        @variable_expression_reduction_analyzer ||=
          VariableExpressionReductionAnalyzer.new
      end

      def constant_expression_reduction_analyzer
        @constant_expression_reduction_analyzer ||=
          ConstantExpressionReductionAnalyzer.new
      end

      def positive_expression_reduction_analyzer
        @positive_expression_reduction_analyzer ||=
          PositiveExpressionReductionAnalyzer.new(self, @sum_partitioner_visitor, @factor_partitioner_visitor)
      end

      def negative_expression_reduction_analyzer
        @negative_expression_reduction_analyzer ||=
          NegativeExpressionReductionAnalyzer
          .new(@expression_factory, @sum_partitioner_visitor, @factor_partitioner_visitor)
      end

      def sum_expression_reduction_analyzer
        @sum_expression_reduction_analyzer ||=
          SumExpressionReductionAnalyzer
          .new(@expression_factory, @sum_partitioner_visitor, @factor_partitioner_visitor)
      end

      def subtract_expression_reduction_analyzer
        @subtract_expression_reduction_analyzer ||=
          SubtractExpressionReductionAnalyzer
          .new(@expression_factory, @sum_partitioner_visitor, @factor_partitioner_visitor)
      end

      def multiplicate_expression_reduction_analyzer
        @multiplicate_expression_reduction_analyzer ||=
          MultiplicateExpressionReductionAnalyzer
          .new(@expression_factory, @sum_partitioner_visitor, @factor_partitioner_visitor)
      end

      def divide_expression_reduction_analyzer
        @divide_expression_reduction_analyzer ||=
          DivideExpressionReductionAnalyzer.new(@expression_factory, self)
      end

      def exponentiate_expression_reduction_analyzer
        @exponentiate_expression_reduction_analyzer ||=
          ExponentiateExpressionReductionAnalyzer.new(@expression_factory, self)
      end

      def natural_logarithm_expression_reduction_analyzer
        @natural_logarithm_expression_reduction_analyzer ||=
          NaturalLogarithmExpressionReductionAnalyzer.new(@expression_factory, self)
      end
    end
  end
end
