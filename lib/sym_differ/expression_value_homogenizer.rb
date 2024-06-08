# frozen_string_literal: true

module SymDiffer
  # Detects if the input to or output of the evaluator are exceptional values (e.g., division by zero exception,
  # Float::INFINITY, Float::NAN) and if so, returns :undefined as the result of any operation.
  class ExpressionValueHomogenizer
    def homogenize
      value = yield
      return :undefined if undefined_value?(value)

      value
    rescue FloatDomainError, ZeroDivisionError, Math::DomainError
      :undefined
    end

    private

    def undefined_value?(value)
      value_is_an_undefined_constant?(value) ||
        value_is_complex?(value) ||
        value_is_not_a_number?(value) ||
        value_is_not_finite?(value)
    end

    def value_is_an_undefined_constant?(value)
      UNDEFINED_CONSTANTS.include?(value)
    end

    def value_is_complex?(value)
      value.is_a?(Complex)
    end

    def value_is_not_a_number?(value)
      value.is_a?(Float) && value.nan?
    end

    def value_is_not_finite?(value)
      value.is_a?(Float) && !value.finite?
    end

    UNDEFINED_CONSTANTS = [:undefined].freeze
    private_constant :UNDEFINED_CONSTANTS
  end
end
