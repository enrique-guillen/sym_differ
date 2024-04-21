# frozen_string_literal: true

module SymDiffer
  module Differentiation
    class PositiveExpressionDeriver
      def initialize(deriver)
        @deriver = deriver
      end

      def derive(expression)
        derive_expression(expression.summand)
      end

      private

      def derive_expression(expression)
        expression.accept(@deriver)
      end
    end
  end
end
