# frozen_string_literal: true

module SymDiffer
  # Returns a value that's close or equal to a fixed point of a function (points where f(x) = x).
  class FixedPointApproximator
    def initialize(tolerance, max_evaluations, expression_evaluator)
      @tolerance = tolerance
      @max_evaluations = max_evaluations
      @expression_evaluator = expression_evaluator
    end

    def approximate(expression, variable, first_guess)
      return if first_guess == :undefined

      @expression = expression
      @variable = variable

      reset_current_evaluation_amount

      new_guess = evaluate_average_damp(first_guess)
      return if new_guess == :undefined

      distance = calculate_distance_between_guesses(first_guess, new_guess)
      evaluate_expression_until_output_distance_low(first_guess, new_guess, distance)
    end

    private

    def evaluate_expression_until_output_distance_low(current_guess, new_guess, distance_between_guesses)
      while greater_than_tolerance?(distance_between_guesses)
        return if current_evaluation_amount_exceeds_max?

        bump_current_evaluation_amount
        new_guess = evaluate_average_damp(current_guess)
        return if new_guess == :undefined

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

    def evaluate_average_damp(value)
      next_value = evaluate_expression(value)
      return :undefined if next_value == :undefined

      (value + next_value) / 2
    end

    def reset_current_evaluation_amount
      @current_evaluation_amount = 0
    end

    def bump_current_evaluation_amount
      self.current_evaluation_amount += 1
    end

    def current_evaluation_amount_exceeds_max?
      self.current_evaluation_amount >= @max_evaluations
    end

    def evaluate_expression(value)
      @expression_evaluator.evaluate(expression, variable => value)
    end

    attr_accessor :current_evaluation_amount
    attr_reader :expression, :variable
  end
end
