# frozen_string_literal: true

require "sym_differ/derivative_of_expression_getter"
require "sym_differ/expression_text_language_compiler/parser"
require "sym_differ/differentiation/differentiation_visitor"
require "sym_differ/expression_reducer"
require "sym_differ/stringifier_visitor"
require "sym_differ/expression_factory"

module SymDiffer
  # Implements the use case for a user getting the derivative of an expression.
  class GetDerivativeOfExpressionInteractor
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
      ExpressionTextLanguageCompiler::Parser.new(expression_factory)
    end

    def differentiation_visitor(variable)
      Differentiation::DifferentiationVisitor.new(variable, expression_factory)
    end

    def expression_reducer
      ExpressionReducer.new(expression_factory)
    end

    def printing_visitor
      StringifierVisitor.new
    end

    def expression_factory
      @expression_factory = ExpressionFactory.new
    end
  end
end
