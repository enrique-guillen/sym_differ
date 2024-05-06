@derive_function @reduce_expression
Feature: Compute the symbolic derivative of a given expression.

  This feature file exposes the internal logic for differentiation. It concerns itself with the mapping between valid expressions and their corresponding derivatives.

  The derivative of a function `F` is a function `F'` that describes the rate of change of the value of the function `F` with respect to one of its parameters.
  The inputs consist of:
  - A string which contains the symbolic expression that defines the function to derive, e.g. `2x + 1`, `sine(x)`, `xy`, etc.
  - A string that specifies the character or name of the parameter of the function, e.g., `x`, `angle`, etc.

  The output is another string, a symbolic expression that defines the computed derivative function, e.g., `2`, `cosine(x)`, `y`, etc. The output is simplified so that it's reasonably compact (e.g., has a smaller number of terms).

  The list of rules is mostly centered around giving a general differentiation rule for each operation with arbitrary functions as parameters.

  See also:
  - The `simplify_expression` feature file to understand how the expressions are simplified.

  Rule: A simple expression can be derived.

    Scenario: The derivative of x, with respect to x, is requested.
      Given the expression to differentiate is x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 1

  Rule: The derivative of a constant is f'(x) = 0.

    Scenario: The derivative of 0, with respect to x, is requested.
      Given the expression to differentiate is 0
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 0

    Scenario: The derivative of 1, with respect to x, is requested.
      Given the expression to differentiate is 1
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 0

  Rule: The derivative of f(x) = x is f'(x) = 1.

    Scenario: The derivative of x, with respect to x, is requested.
      Given the expression to differentiate is x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 1

  Rule: The derivative of f(x) = -a(x) is f'(x) = -a'(x).

    Scenario: The derivative of -x, with respect to x, is requested.
      Given the expression to differentiate is -x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is -1

    Scenario: The derivative of -2, with respect to x, is requested.
      Given the expression to differentiate is -2
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 0

    Scenario: The derivative of 1 + --x, with respect to x, is requested.
      Given the expression to differentiate is 1 + --x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 1

  Rule: The derivative of f(x) = a(x) - b(x) is f'(x) = a'(x) - b'(x).
    Scenario: The derivative of x - x - x, with respect to x, is requested.
      Given the expression to differentiate is x - x - x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is -1

  Rule: The derivative of f(x) = +a(x) is f'(x) = a'(x).
    Scenario: The derivative of +x, with respect to x, is requested.
      Given the expression to differentiate is +x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 1

  Rule: The derivative of f(x) = a(x) * b(x) is f'(x) = a'(x) * b(x) + a(x) * b'(x).

    Scenario: The derivative of x * x, with respect to x, is requested.
      Given the expression to differentiate is x * x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is x + x
      And (@wip) the derivative expression is 2x

    Scenario: The derivative of x * 2 * x, with respect to x, is requested.
      Given the expression to differentiate is x * 2 * x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 2 * x + 2 * x
      And (@wip) the derivative expression is 4x

    Scenario: The derivative of x - x * x - x * x, with respect to x, is requested.
      Given the expression to differentiate is x - x * x - x * x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is -(x + x) - (x + x) + 1
      And (@wip) the derivative expression is 1 - 4x

    Scenario: The derivative of 2 * x - 2 * x, with respect to x, is requested.
      Given the expression to differentiate is 2 * x - 2 * x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 0

  Rule: The derivative of f(x) = sin(x) is f'(x) = cos(x), and the chain rule is applied as well.

    Scenario: The derivative of sin(x), with respect to x, is requested.
      Given the expression to differentiate is sine(x)
      And the variable of the expression to differentiate with is x

      When (@wip) the expression is computed

      Then (@wip) the derivative expression is derivative(sine(x))
      Then (@wip) the derivative expression is cos(x)

    Scenario: The derivative of sine(2 * x), with respect to x, is requested.
      Given the expression to differentiate is sine(2 * x)
      And the variable of the expression to differentiate with is x

      When (@wip) the expression is computed

      Then (@wip) the derivative expression is 2 * sine(2 * x)

    Scenario: The derivative of sine(x * x), with respect to x, is requested.
      Given the expression to differentiate is sine(x * x)
      And the variable of the expression to differentiate with is x

      When (@wip) the expression is computed

      Then (@wip) the derivative expression is (cos(x * x)) * (x + x)
