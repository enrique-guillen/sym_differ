# frozen_string_literal: true

module SymDiffer
  # Returns a value that's close or equal to a fixed point of a function (points where f(x) = x).
  class FixedPointApproximator
    def initialize(tolerance, expression_evaluator)
      @tolerance = tolerance
      @expression_evaluator = expression_evaluator
    end

    def approximate(expression, variable, first_guess)
      @expression = expression
      @variable = variable

      new_guess = evaluate_expression(first_guess)
      distance = calculate_distance_between_guesses(first_guess, new_guess)
      evaluate_expression_until_output_distance_low(first_guess, new_guess, distance)
    end

    private

    def evaluate_expression_until_output_distance_low(current_guess, new_guess, distance_between_guesses)
      while greater_than_tolerance?(distance_between_guesses)
        new_guess = evaluate_expression(current_guess)

        distance_between_guesses = calculate_distance_between_guesses(current_guess, new_guess)
        current_guess = new_guess
      end

      new_guess
    end

    def calculate_distance_between_guesses(guess_1, guess_2)
      (guess_1 - guess_2).abs
    end

    def greater_than_tolerance?(distance)
      distance > @tolerance
    end

    def evaluate_expression(value)
      @expression_evaluator.evaluate(expression, variable => value)
    end

    attr_reader :expression, :variable
  end
end
