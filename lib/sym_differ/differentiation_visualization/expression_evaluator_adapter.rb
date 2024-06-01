# frozen_string_literal: true

require "sym_differ/expression_evaluator_visitor"

module SymDiffer
  # Implements the use case for a user getting the graph image of an expression and its derivative.
  module DifferentiationVisualization
    # Adapts the ExpressionEvaluatorVisitor interface to match what's expected by NewtonMethodRootFinder.
    class ExpressionEvaluatorAdapter
      def evaluate(expression, variable_values)
        ExpressionEvaluatorVisitor.new(variable_values).evaluate(expression)
      end
    end
  end
end
