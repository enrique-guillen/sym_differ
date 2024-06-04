# frozen_string_literal: true

module SymDiffer
  # Detects if the input to or output of the evaluator are exceptional values (e.g., division by zero exception,
  # Float::INFINITY, Float::NAN) and if so, returns :undefined as the result of any operation.
  class ExpressionValueHomogenizer
    def homogenize
      value = yield
      return :undefined if undefined_value?(value)

      value
    rescue FloatDomainError, ZeroDivisionError
      :undefined
    end

    private

    def undefined_value?(value)
      UNDEFINED_CONSTANTS.include?(value)
    end

    UNDEFINED_CONSTANTS = [:undefined, Float::NAN, Float::INFINITY].freeze
    private_constant :UNDEFINED_CONSTANTS
  end
end
