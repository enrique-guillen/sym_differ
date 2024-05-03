# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Tokens
      # Token representing a constant value appearing in an expression in text form.
      class ConstantToken
        def initialize(value)
          @value = value
        end

        attr_reader :value
      end
    end
  end
end
