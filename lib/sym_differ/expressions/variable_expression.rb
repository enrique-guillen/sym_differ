# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents an expression with a variable value.
    class VariableExpression
      def initialize(name)
        @name = name
      end

      def accept(visitor)
        visitor.visit_variable_expression(self)
      end

      attr_reader :name
    end
  end
end
