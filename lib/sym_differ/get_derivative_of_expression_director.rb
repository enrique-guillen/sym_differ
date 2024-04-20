# frozen_string_literal: true

require "sym_differ/derivative_of_expression_getter"
require "sym_differ/expression_text_language_compiler/parser"
require "sym_differ/differentiation/differentiation_visitor"
require "sym_differ/expression_reducer"
require "sym_differ/inline_printing/printing_visitor"

module SymDiffer
  # Implements the use case for a user getting the derivative of an expression.
  class GetDerivativeOfExpressionDirector
    def calculate_derivative(expression_text, variable)
      DerivativeOfExpressionGetter
        .new(parser,
             differentiation_visitor(variable),
             expression_reducer,
             printing_visitor)
        .get(expression_text, variable)
    end

    private

    def parser
      SymDiffer::ExpressionTextLanguageCompiler::Parser.new(
        SymDiffer::ExpressionFactory.new
      )
    end

    def differentiation_visitor(variable)
      SymDiffer::Differentiation::DifferentiationVisitor.new(variable)
    end

    def expression_reducer
      SymDiffer::ExpressionReducer.new
    end

    def printing_visitor
      SymDiffer::InlinePrinting::PrintingVisitor.new
    end
  end
end
