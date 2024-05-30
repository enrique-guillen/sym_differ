# frozen_string_literal: true

module SymDiffer
  # Invokes the provided block for each node in the abstract expression tree.
  class ExpressionWalkerVisitor
    def initialize(yield_at_list)
      @yield_at_list = yield_at_list.to_set
    end

    attr_reader :yield_at_list

    def walk(expression, yield_at_list, &)
      @yield_at_list = yield_at_list.to_set
      expression.accept(self, &)
    end

    def visit_constant_expression(expression)
      yield(expression) if yield_at_list_includes?(:constants)
    end

    def visit_variable_expression(expression)
      yield(expression) if yield_at_list_includes?(:variables)
    end

    def visit_positive_expression(expression, &)
      yield(expression) if yield_at_list_includes?(:positives)

      walk_to_nested_expression(expression.summand, &)
    end

    def visit_negate_expression(expression, &)
      yield(expression) if yield_at_list_includes?(:negatives)

      walk_to_nested_expression(expression.negated_expression, &)
    end

    def visit_sum_expression(expression, &block)
      yield(expression) if yield_at_list_includes?(:sums)

      [expression.expression_a, expression.expression_b].each do |subexpression|
        walk_to_nested_expression(subexpression, &block)
      end
    end

    def visit_subtract_expression(expression, &block)
      yield(expression) if yield_at_list_includes?(:subtractions)

      [expression.minuend, expression.subtrahend].each do |subexpression|
        walk_to_nested_expression(subexpression, &block)
      end
    end

    def visit_multiplicate_expression(expression, &block)
      yield(expression) if yield_at_list_includes?(:multiplications)

      [expression.multiplicand, expression.multiplier].each do |subexpression|
        walk_to_nested_expression(subexpression, &block)
      end
    end

    def visit_divide_expression(expression, &block)
      yield(expression) if yield_at_list_includes?(:divisions)

      [expression.numerator, expression.denominator].each do |subexpression|
        walk_to_nested_expression(subexpression, &block)
      end
    end

    def visit_exponentiate_expression(expression, &block)
      yield(expression) if yield_at_list_includes?(:exponentiations)

      [expression.base, expression.power].each do |subexpression|
        walk_to_nested_expression(subexpression, &block)
      end
    end

    def visit_sine_expression(expression, &)
      yield(expression) if yield_at_list_includes?(:sines)

      walk_to_nested_expression(expression.angle_expression, &)
    end

    def visit_cosine_expression(expression, &)
      yield(expression) if yield_at_list_includes?(:cosines)

      walk_to_nested_expression(expression.angle_expression, &)
    end

    private

    def yield_at_list_includes?(expression_type)
      @yield_at_list.include?(expression_type)
    end

    def walk_to_nested_expression(expression, &)
      expression.accept(self, &)
    end
  end
end
