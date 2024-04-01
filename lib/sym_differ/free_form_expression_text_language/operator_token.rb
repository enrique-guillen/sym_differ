# frozen_string_literal: true

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Token representing a prefix, infix, or postfix operator appearing in an expression text.
    class OperatorToken
      def initialize(symbol)
        @symbol = symbol
      end

      attr_reader :symbol
    end
  end
end
