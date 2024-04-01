# frozen_string_literal: true

module SymDiffer
  module FreeFormExpressionTextLanguage
    # Token representing a variable name in an expression in text form.
    class VariableToken
      def initialize(name)
        @name = name
      end

      attr_reader :name
    end
  end
end
