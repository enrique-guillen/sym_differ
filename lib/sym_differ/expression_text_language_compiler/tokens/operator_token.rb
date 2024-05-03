# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Tokens
      # Token representing an infix operator appearing in an expression text.
      class OperatorToken
        def initialize(symbol)
          @symbol = symbol
        end

        attr_reader :symbol
      end
    end
  end
end
