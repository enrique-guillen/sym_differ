# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Tokens
      # Token representing a specific constant real value, usually having a specific name (e.g., e, pi).
      class SpecialNamedConstantToken
        def initialize(text)
          @text = text
        end

        attr_reader :text
      end
    end
  end
end
