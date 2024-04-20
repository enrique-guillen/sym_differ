# frozen_string_literal: true

require "sym_differ/constant_expression"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Token representing a constant value appearing in an expression in text form.
    class ConstantToken
      def initialize(value)
        @value = value
      end

      attr_reader :value
    end
  end
end
