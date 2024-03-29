# frozen_string_literal: true

module SymDiffer
  # Implements the use case for a user getting the derivative of an expression.
  class DerivativeOfExpressionGetter
    DerivativeOfExpressionGetterResponse = Struct.new(:successful?, :derivative_expression)

    def get(_expression, _variable)
      DerivativeOfExpressionGetterResponse.new(true, "1")
    end
  end
end
