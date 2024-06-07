# frozen_string_literal: true

module SymDiffer
  # Methods for displaying all the elements of an expression into a single inline string.
  class StringifierVisitor
    def initialize(parenthesize_infix_expressions: false)
      @parenthesize_infix_expressions = parenthesize_infix_expressions
    end

    attr_reader :parenthesize_infix_expressions

    def stringify(expression)
      expression.accept(self)
    end

    def visit_constant_expression(expression)
      expression.value.to_s
    end

    def visit_variable_expression(expression)
      expression.name
    end

    def visit_negate_expression(expression)
      nested_visitor = build_visitor(parenthesize_infix_expressions: true)

      stringified_negated_expression = stringify_expression(expression.negated_expression, visitor: nested_visitor)

      prefix_with_symbol("-", stringified_negated_expression)
    end

    def visit_positive_expression(expression)
      nested_visitor = build_visitor(parenthesize_infix_expressions: true)

      stringified_summand = stringify_expression(expression.summand, visitor: nested_visitor)

      prefix_with_symbol("+", stringified_summand)
    end

    def visit_sum_expression(expression)
      nested_visitor = build_visitor(parenthesize_infix_expressions: true)

      stringified_expression_a = stringify_expression(expression.expression_a, visitor: nested_visitor)
      stringified_expression_b = stringify_expression(expression.expression_b, visitor: nested_visitor)
      result = join_expressions_with_infix_operator("+", stringified_expression_a, stringified_expression_b)

      (result = surround_in_parenthesis(result)) if should_parenthesize_infix_expression?

      result
    end

    def visit_subtract_expression(expression)
      nested_visitor = build_visitor(parenthesize_infix_expressions: true)

      stringified_minuend = stringify_expression(expression.minuend, visitor: nested_visitor)
      stringified_subtrahend = stringify_expression(expression.subtrahend, visitor: nested_visitor)
      result = join_expressions_with_infix_operator("-", stringified_minuend, stringified_subtrahend)

      (result = surround_in_parenthesis(result)) if should_parenthesize_infix_expression?

      result
    end

    def visit_multiplicate_expression(expression)
      nested_visitor = build_visitor(parenthesize_infix_expressions: true)

      stringified_multiplicand = stringify_expression(expression.multiplicand, visitor: nested_visitor)
      stringified_multiplier = stringify_expression(expression.multiplier, visitor: nested_visitor)

      result = join_expressions_with_infix_operator("*", stringified_multiplicand, stringified_multiplier)

      (result = surround_in_parenthesis(result)) if should_parenthesize_infix_expression?

      result
    end

    def visit_derivative_expression(expression)
      nested_visitor = build_visitor(parenthesize_infix_expressions: false)

      stringified_underived_expression = stringify_expression(expression.underived_expression, visitor: nested_visitor)
      stringified_variable_expression = stringify_expression(expression.variable, visitor: nested_visitor)
      stringified_arguments = join_with_commas(stringified_underived_expression, stringified_variable_expression)

      join_function_name_and_arguments("derivative", stringified_arguments)
    end

    def visit_sine_expression(expression)
      nested_visitor = build_visitor(parenthesize_infix_expressions: false)
      stringified_angle_expression = stringify_expression(expression.angle_expression, visitor: nested_visitor)
      join_function_name_and_arguments("sine", stringified_angle_expression)
    end

    def visit_cosine_expression(expression)
      nested_visitor = build_visitor(parenthesize_infix_expressions: false)
      stringified_angle_expression = stringify_expression(expression.angle_expression, visitor: nested_visitor)
      join_function_name_and_arguments("cosine", stringified_angle_expression)
    end

    def visit_divide_expression(expression)
      nested_visitor = build_visitor(parenthesize_infix_expressions: true)

      stringified_numerator = stringify_expression(expression.numerator, visitor: nested_visitor)
      stringified_denominator = stringify_expression(expression.denominator, visitor: nested_visitor)

      result = join_expressions_with_infix_operator("/", stringified_numerator, stringified_denominator)

      (result = surround_in_parenthesis(result)) if should_parenthesize_infix_expression?

      result
    end

    def visit_exponentiate_expression(expression)
      nested_visitor = build_visitor(parenthesize_infix_expressions: true)

      stringified_base = stringify_expression(expression.base, visitor: nested_visitor)
      stringified_power = stringify_expression(expression.power, visitor: nested_visitor)

      result = join_expressions_with_infix_operator("^", stringified_base, stringified_power)

      (result = surround_in_parenthesis(result)) if should_parenthesize_infix_expression?

      result
    end

    def visit_euler_number_expression(_expression)
      "~e"
    end

    def visit_natural_logarithm_expression(expression)
      nested_visitor = build_visitor(parenthesize_infix_expressions: false)
      stringified_power_expression = stringify_expression(expression.power, visitor: nested_visitor)
      join_function_name_and_arguments("ln", stringified_power_expression)
    end

    private

    def prefix_with_symbol(symbol, expression)
      "#{symbol}#{expression}"
    end

    def surround_in_parenthesis(expression)
      "(#{expression})"
    end

    def join_function_name_and_arguments(function_name, arguments)
      "#{function_name}(#{arguments})"
    end

    def join_expressions_with_infix_operator(operator, expression_a, expression_b)
      "#{expression_a} #{operator} #{expression_b}"
    end

    def join_with_commas(*argument_list)
      argument_list.join(", ")
    end

    def stringify_expression(expression, visitor: self)
      expression.accept(visitor)
    end

    def should_parenthesize_infix_expression?
      @parenthesize_infix_expressions
    end

    def build_visitor(parenthesize_infix_expressions: false)
      self.class.new(parenthesize_infix_expressions:)
    end
  end
end
