# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Represents an expression representing a fixed value.
    class ConstantExpression
      def initialize(value)
        @value = value
      end

      def accept(visitor)
        visitor.visit_constant_expression(self)
      end

      attr_reader :value
    end
  end
end
