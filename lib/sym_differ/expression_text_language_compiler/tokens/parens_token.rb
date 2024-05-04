# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    module Tokens
      # Token representing an opening or closing parenthesis appearing in an expression in text form.
      class ParensToken
        def initialize(type)
          @type = type
        end

        attr_reader :type
      end
    end
  end
end
