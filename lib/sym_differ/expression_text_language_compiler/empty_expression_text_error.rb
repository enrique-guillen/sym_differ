# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    # Error to raise when an attempt to parse an empty string is made.
    class EmptyExpressionTextError < StandardError
    end
  end
end
