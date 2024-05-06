# frozen_string_literal: true

module SymDiffer
  module Expressions
    class DerivativeExpression
      def initialize(underived_expression, variable)
        @underived_expression = underived_expression
        @variable = variable
      end

      attr_reader :underived_expression, :variable
    end
  end
end
