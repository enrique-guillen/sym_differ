# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Tokens
      # Token representing a variable name in an expression in text form.
      class IdentifierToken
        def initialize(name)
          @name = name
        end

        attr_reader :name
      end
    end
  end
end
