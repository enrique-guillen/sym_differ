# frozen_string_literal: true

require "sym_differ/sum_expression"
require "sym_differ/negate_expression"
require "sym_differ/subtract_expression"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Token representing an infix operator appearing in an expression text.
    class OperatorToken
      def initialize(symbol)
        @symbol = symbol
      end

      attr_reader :symbol
    end
  end
end
