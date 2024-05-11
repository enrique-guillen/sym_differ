# frozen_string_literal: true

require "sym_differ/invalid_variable_given_to_expression_parser_error"
require "sym_differ/unparseable_expression_text_error"

module SymDiffer
  # Implements the use case for a user getting the derivative of an expression.
  class DerivativeOfExpressionGetter
    # Defines the high-level response of this use case.
    OperationResponse = Struct.new(:derivative_expression)

    def initialize(expression_text_parser, differentiation_visitor, expression_reducer, expression_stringifier)
      @expression_text_parser = expression_text_parser
      @differentiation_visitor = differentiation_visitor
      @expression_reducer = expression_reducer
      @expression_stringifier = expression_stringifier
    end

    def get(expression_text, variable)
      build_compute_derivative_expression_operation_result(expression_text, variable)
    end

    private

    def build_compute_derivative_expression_operation_result(expression_text, variable)
      expression = validate_expression_and_compute_derivative_expression(expression_text, variable)
      build_operation_response(expression)
    end

    def validate_expression_and_compute_derivative_expression(expression_text, variable)
      validate_variable(variable)

      parse_expression_text(expression_text)
        .then { |expression| derive_expression(expression) }
        .then { |expression| reduce_expression(expression) }
        .then { |expression| textify_expression(expression) }
    end

    def validate_variable(variable)
      @expression_text_parser.validate_variable(variable)
    end

    def build_operation_response(derivative_expression)
      OperationResponse.new(derivative_expression)
    end

    def parse_expression_text(expression_text)
      @expression_text_parser.parse(expression_text)
    end

    def derive_expression(expression)
      expression.accept(@differentiation_visitor)
    end

    def reduce_expression(expression)
      @expression_reducer.reduce(expression)
    end

    def textify_expression(expression)
      @expression_stringifier.stringify(expression)
    end
  end
end
