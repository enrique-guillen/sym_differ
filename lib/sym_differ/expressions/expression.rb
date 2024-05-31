# frozen_string_literal: true

module SymDiffer
  module Expressions
    # Parent abstract Expression call.
    class Expression
      def accept(visitor, *, &)
        visitor.visit_abstract_expression(self, *, &)
      end
    end
  end
end
