# frozen_string_literal: true

require "sym_differ/inline_printing/printing_visitor"

module SymDiffer
  # Allows converting an Expression into an inline textual representation of the expression, and from a free form
  # expression text into an Expression.
  module ParsingSupport
    def parse_expression(expression_text)
      SymDiffer::FreeFormExpressionTextLanguage::Parser.new.parse(expression_text)
    end

    def inline_expression(expression)
      expression.accept(SymDiffer::InlinePrinting::PrintingVisitor.new)
    end
  end
end

World(SymDiffer::ParsingSupport)
