# frozen_string_literal: true

require "sym_differ/derivative_of_expression_getter"
require "sym_differ/free_form_expression_text_language/parser"
require "sym_differ/differentiation/differentiation_visitor"
require "sym_differ/expression_reducer"
require "sym_differ/inline_printing/printing_visitor"

module SymDiffer
  # Implements the use case for a user getting the derivative of an expression.
  class GetDerivativeOfExpressionDirector
    def calculate_derivative(expression_text, variable)
      DerivativeOfExpressionGetter
        .new(SymDiffer::FreeFormExpressionTextLanguage::Parser.new,
             SymDiffer::Differentiation::DifferentiationVisitor.new(variable),
             SymDiffer::ExpressionReducer.new,
             SymDiffer::InlinePrinting::PrintingVisitor.new)
        .get(expression_text, variable)
    end
  end
end
