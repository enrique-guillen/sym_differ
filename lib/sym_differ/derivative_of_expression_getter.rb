# frozen_string_literal: true

require "sym_differ/invalid_variable_given_to_expression_parser_error"
require "sym_differ/unparseable_expression_text_error"

module SymDiffer
  # Implements the use case for a user getting the derivative of an expression.
  class DerivativeOfExpressionGetter
    OperationResponse = Struct.new(:successful?, :derivative_expression, :message, :cause)

    def initialize(expression_text_parser, differentiation_visitor_builder, expression_reducer, expression_textifier)
      @expression_text_parser = expression_text_parser
      @differentiation_visitor_builder = differentiation_visitor_builder
      @expression_reducer = expression_reducer
      @expression_textifier = expression_textifier
    end

    def get(expression_text, variable)
      build_compute_derivative_expression_operation_result(expression_text, variable)
    rescue InvalidVariableGivenToExpressionParserError, UnparseableExpressionTextError => e
      build_failure_operation_response(e)
    end

    private

    def build_compute_derivative_expression_operation_result(expression_text, variable)
      expression = validate_expression_and_compute_derivative_expression(expression_text, variable)
      build_operation_response(true, expression)
    end

    def build_failure_operation_response(exception)
      build_operation_response(false, nil, "See #cause for details.", exception)
    end

    def validate_expression_and_compute_derivative_expression(expression_text, variable)
      validate_variable(variable)

      parse_expression_text(expression_text)
        .then { |expression| derive_expression(expression, variable) }
        .then { |expression| reduce_expression(expression) }
        .then { |expression| textify_expression(expression) }
    end

    def validate_variable(variable)
      @expression_text_parser.validate_variable(variable)
    end

    def build_operation_response(was_successful, derivative_expression, message = nil, cause = nil)
      OperationResponse.new(was_successful, derivative_expression, message, cause)
    end

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
