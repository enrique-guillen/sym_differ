# frozen_string_literal: true

require "sym_differ/error"

module SymDiffer
  module ExpressionTextLanguageCompiler
    # In the expression text, a part of the expression was correct function-application syntax, but the name of the
    # function is not recognized.
    class UnrecognizedFunctionNameError < SymDiffer::Error
      def accept(visitor)
        visitor.visit_unrecognized_function_name_error(self)
      end
    end
  end
end
