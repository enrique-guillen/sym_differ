# frozen_string_literal: true

require "sym_differ/expression_reduction/sum_partitioner_visitor"
require "sym_differ/expression_reduction/factor_partitioner_visitor"
require "sym_differ/expression_reduction/reducer_visitor"

module SymDiffer
  # Reduces the terms in the provided expression.
  class ExpressionReducer
    def initialize(expression_factory)
      @expression_factory = expression_factory
    end

    def reduce(expression)
      assign_expression_reducer_of_sum_partitioner_visitor(reducer_visitor)
      assign_factor_partitioner_of_sum_partitioner_visitor(factor_partitioner_visitor)

      reducer_visitor.reduce(expression)
    end

    private

    def assign_expression_reducer_of_sum_partitioner_visitor(reducer)
      sum_partitioner_visitor.expression_reducer = reducer
    end

    def assign_factor_partitioner_of_sum_partitioner_visitor(partitioner)
      sum_partitioner_visitor.factor_partitioner = partitioner
    end

    def reduce_expression(expression)
      reducer_visitor.reduce(expression)
    end

    def reducer_visitor
      @reducer_visitor ||=
        ExpressionReduction::ReducerVisitor.new(
          @expression_factory,
          sum_partitioner_visitor,
          factor_partitioner_visitor
        )
    end

    def factor_partitioner_visitor
      @factor_partitioner_visitor ||=
        ExpressionReduction::FactorPartitionerVisitor.new(@expression_factory, sum_partitioner_visitor)
    end

    def sum_partitioner_visitor
      @sum_partitioner_visitor ||=
        ExpressionReduction::SumPartitionerVisitor.new(@expression_factory)
    end
  end
end
