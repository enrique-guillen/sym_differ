# frozen_string_literal: true

module SymDiffer
  module ExpressionTextLanguageCompiler
    # An abstract data type that provides high-level access methods to strings that represent expression texts.
    class ExpressionText
      def initialize(initial_text)
        @text = initial_text
      end

      attr_accessor :text

      def first_character_in_text
        @text[0]
      end

      def tail_end_of_text
        @text[1, @text.size].to_s
      end

      def empty?
        @text.empty?
      end
    end
  end
end
