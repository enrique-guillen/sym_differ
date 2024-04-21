# frozen_string_literal: true

require "sym_differ/expressions/variable_expression"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Token representing a variable name in an expression in text form.
    class VariableToken
      def initialize(name)
        @name = name
      end

      attr_reader :name
    end
  end
end
