# frozen_string_literal: true

module SymDiffer
  # Implements the use case for a user getting the derivative of an expression.
  class DerivativeOfExpressionGetter
    DerivativeOfExpressionGetterResponse = Struct.new(:successful?, :derivative_expression)

    def initialize(expression_text_parser, differentiation_visitor_builder, expression_reducer, expression_textifier)
      @expression_text_parser = expression_text_parser
      @differentiation_visitor_builder = differentiation_visitor_builder
      @expression_reducer = expression_reducer
      @expression_textifier = expression_textifier
    end

    def get(expression_text, variable)
      DerivativeOfExpressionGetterResponse.new(
        true,
        parse_expression_text(expression_text)
          .then { |expression| derive_expression(expression, variable) }
          .then { |expression| reduce_expression(expression) }
          .then { |expression| textify_expression(expression) }
      )
    end

    private

    def parse_expression_text(expression_text)
      @expression_text_parser.parse(expression_text)
    end

    def derive_expression(expression, variable)
      @differentiation_visitor_builder.build(variable).derive(expression)
    end

    def reduce_expression(expression)
      @expression_reducer.reduce(expression)
    end

    def textify_expression(expression)
      @expression_textifier.textify(expression)
    end
  end
end
