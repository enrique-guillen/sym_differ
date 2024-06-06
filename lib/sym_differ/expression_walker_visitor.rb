# frozen_string_literal: true

module SymDiffer
  # Invokes the provided block for each node in the abstract expression tree.
  class ExpressionWalkerVisitor
    def initialize(yield_at_list = {})
      @yield_at_list = yield_at_list.to_set
    end

    attr_reader :yield_at_list

    def walk(expression, yield_at:, &)
      @yield_at_list = yield_at.to_set
      expression.accept(self, &)
    end

    def visit_constant_expression(expression, &)
      yield_if_list_includes(expression, :constants, &)
    end

    def visit_variable_expression(expression, &)
      yield_if_list_includes(expression, :variables, &)
    end

    def visit_positive_expression(expression, &)
      yield_if_list_includes(expression, :positives, &)

      walk_to_nested_expression(expression.summand, &)
    end

    def visit_negate_expression(expression, &)
      yield_if_list_includes(expression, :negatives, &)

      walk_to_nested_expression(expression.negated_expression, &)
    end

    def visit_sum_expression(expression, &block)
      yield_if_list_includes(expression, :sums, &block)

      [expression.expression_a, expression.expression_b].each do |subexpression|
        walk_to_nested_expression(subexpression, &block)
      end
    end

    def visit_subtract_expression(expression, &block)
      yield_if_list_includes(expression, :subtractions, &block)

      [expression.minuend, expression.subtrahend].each do |subexpression|
        walk_to_nested_expression(subexpression, &block)
      end
    end

    def visit_multiplicate_expression(expression, &block)
      yield_if_list_includes(expression, :multiplications, &block)

      [expression.multiplicand, expression.multiplier].each do |subexpression|
        walk_to_nested_expression(subexpression, &block)
      end
    end

    def visit_divide_expression(expression, &block)
      yield_if_list_includes(expression, :divisions, &block)

      [expression.numerator, expression.denominator].each do |subexpression|
        walk_to_nested_expression(subexpression, &block)
      end
    end

    def visit_exponentiate_expression(expression, &block)
      yield_if_list_includes(expression, :exponentiations, &block)

      [expression.base, expression.power].each do |subexpression|
        walk_to_nested_expression(subexpression, &block)
      end
    end

    def visit_sine_expression(expression, &)
      yield_if_list_includes(expression, :sines, &)
      walk_to_nested_expression(expression.angle_expression, &)
    end

    def visit_cosine_expression(expression, &)
      yield_if_list_includes(expression, :cosines, &)
      walk_to_nested_expression(expression.angle_expression, &)
    end

    def visit_euler_number_expression(expression, &)
      yield_if_list_includes(expression, :euler_numbers, &)
    end

    def visit_natural_logarithm_expression(expression, &)
      yield_if_list_includes(expression, :natural_logarithms, &)
      walk_to_nested_expression(expression.power, &)
    end

    private

    def yield_if_list_includes(expression, yield_at_list_member, &)
      yield(expression) if yield_at_list_includes?(yield_at_list_member)
    end

    def yield_at_list_includes?(expression_type)
      @yield_at_list.include?(expression_type)
    end

    def walk_to_nested_expression(expression, &)
      expression.accept(self, &)
    end
  end
end
