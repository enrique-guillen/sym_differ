# frozen_string_literal: true

require "sym_differ/variable_expression"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Token representing a variable name in an expression in text form.
    class VariableToken
      def initialize(name)
        @name = name
      end

      attr_reader :name

      def transform_into_expression
        VariableExpression.new(@name)
      end
    end
  end
end
