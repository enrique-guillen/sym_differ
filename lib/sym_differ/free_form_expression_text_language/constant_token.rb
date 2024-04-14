# frozen_string_literal: true

require "sym_differ/constant_expression"

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Token representing a constant value appearing in an expression in text form.
    class ConstantToken
      def initialize(value)
        @value = value
      end

      attr_reader :value

      def transform_into_expression
        ConstantExpression.new(@value)
      end
    end
  end
end
