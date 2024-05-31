# frozen_string_literal: true

require "forwardable"

module SymDiffer
  # Tries to fine one discontinuity of the expression within the provided range.
  class DiscontinuitiesDetector
    extend Forwardable

    def initialize(root_finder, expression_walker, numerical_analysis_item_factory)
      @root_finder = root_finder
      @expression_walker = expression_walker
      @numerical_analysis_item_factory = numerical_analysis_item_factory
    end

    def find(expression, variable_name, range)
      root = walk_expression_until_root_found(expression, variable_name, range)

      create_evaluation_point(root, :undefined) unless root.nil?
    end

    private

    def walk_expression_until_root_found(expression, variable_name, range)
      root = nil

      walk_expression(expression, yield_at: %i[divisions]) do |division_expression|
        first_guesses = generate_first_guesses(range)
        root = try_guesses_for_roots(first_guesses, division_expression.denominator, variable_name, range)

        break unless root.nil?
      end

      root
    end

    def try_guesses_for_roots(guesses, expression, variable_name, range)
      guesses
        .lazy
        .map { |first_guess| find_root(expression, variable_name, first_guess) }
        .detect { |root| root_contained_within_open_range?(range, root) }
    end

    def generate_first_guesses(range)
      mid_point = (range.first + range.last) / 2.0
      start_point = range.min
      end_point = range.max

      [mid_point, start_point, end_point]
    end

    def root_contained_within_open_range?(range, root)
      range.include?(root) && range.first != root && range.last != root
    end

    def_delegator :@expression_walker, :walk, :walk_expression
    def_delegator :@root_finder, :find, :find_root
    def_delegator :@numerical_analysis_item_factory, :create_evaluation_point
  end
end
