# frozen_string_literal: true

require "sym_differ/expressions/expression"

module SymDiffer
  module Expressions
    # Represents an expression with a variable value.
    class VariableExpression < Expression
      def initialize(name)
        @name = name
        super()
      end

      attr_reader :name

      def accept(visitor)
        visitor.visit_variable_expression(self)
      end

      def same_as?(other_expression)
        other_expression.is_a?(VariableExpression) && name == other_expression.name
      end
    end
  end
end
