@derive_function @reduce_expression
Feature: Compute the symbolic derivative of a given expression.

  The derivative of a function `F` is a function `F'` that describes the rate of change of the value of the function `F` with respect to one of its parameters.

  This feature file concerns itself with the mapping between valid expressions and their corresponding derivatives.

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

  Rule: The derivative of f(x) = a(x) + b(x) is f'(x) = a'(x) + b'(x).

    Scenario: The derivative of x + 1, with respect to x, is requested.
      Given the expression to differentiate is x + 1
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 1

    Scenario: The derivative of x + -x, with respect to x, is requested.
      Given the expression to differentiate is x + -x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 0

    Scenario: The derivative of x + -x + -x, with respect to x, is requested.
      Given the expression to differentiate is x + -x + -x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is -x

  Rule: The derivative of f(x) = a(x) - b(x) is f'(x) = a'(x) - b'(x).

    Scenario: The derivative of x - x - x, with respect to x, is requested.
      Given the expression to differentiate is x - x - x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is -x

  Rule: The derivative of f(x) = a(x)b(x) is f'(x) = a'(x)b(x) + a(x)b'(x).

    Scenario: The derivative of x * (x + x), with respect to x, is requested.
      Given the expression to differentiate is x * (x + x)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 4x

    Scenario: The derivative of x * (2 * x), with respect to x, is requested.
      Given the expression to differentiate is x * (2 * x)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 4x

  Rule: The derivative of f(x) = <e>x, where <e> is the Euler constant, is f'(x) = <e>^x.

    Scenario: The derivative of <e> ^ x, with respect to x, is requested.
      Given the expression to differentiate is <e> ^ x
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is <e> ^ x

    Scenario: The derivative of (<e> ^ x) + (<e> ^ x), with respect to x, is requested.
      Given the expression to differentiate is (<e> ^ x) + (<e> ^ x)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 2<e> ^ x

  Rule: The derivative of f(x) = <ln>(x), where <ln> is the natural logarithm function, is f'(x) = 1 / x.

    Scenario: The derivative of <ln>(x), with repect to x, is requested.
      Given the expression to differentiate is <ln>(x)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 1 / x

    Scenario: The derivative of 2 * <ln>(x) with repect to x, is requested.
      Given the expression to differentiate is 2 * <ln>(x)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 2 / x

  Rule: The derivative of f(x) = a(b(x)) is f'(x) = a'(b(x)) * b'(x).

    Scenario: The derivative of <e> ^ (2 * x), with repect to x, is requested.
      Given the expression to differentiate is <e> ^ (2 * x)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 2<e>^(2x)

    Scenario: The derivative of <ln>(x ^ 2), with repect to x, is requested.
      Given the expression to differentiate is <ln>(x ^ 2)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is 2/x

  Rule: The function f(x) = a(x)^b(x) is equivalent to f(x) = e^(<ln>(a(x) ^ b(x))). Therefore, by the chain rule, the derivative of the function is f'(x) = e^(b(x)<ln>(a(x))) * (b'(x)<ln>(a(x)) + b(x)(a'(x) / a(x)))
    Scenario: The derivative of x ^ (2 * x), is requested.
      Given the expression to differentiate is x ^ (2 * x)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is <e>^(2*x*<ln>(x)) * (2*<ln>(x) + 2)

    Scenario: The derivative of (2 * x) ^ (2 * x), with repect to x, is requested.
      Given the expression to differentiate is x ^ (2 * x)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is <e>^(2x*<ln>(2x)) * (2*<ln>(2x) + 2)

  Rule: The function f(x) = <sin>(x), where <sin> is the sine function, is f'(x) = <cos>(x).

    Scenario: The derivative of <sin>(x), with repect to x, is requested.
      Given the expression to differentiate is <sin>(x)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is <cos>(x)

    Scenario: The derivative of <sin>(2 * x), with repect to x, is requested.
      Given the expression to differentiate is <sin>(2x)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is <cos>(2x) * 2

  Rule: The function f(x) = <cos>(x), where <cos> is the cosine function, is f'(x) = -<sine>(x).

    Scenario: The derivative of <cos>(x), with repect to x, is requested.
      Given the expression to differentiate is <cos>(x)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is -<sin>(x)

    Scenario: The derivative of <cos>(2 * x), with repect to x, is requested.
      Given the expression to differentiate is <cos>(2x)
      And the variable of the expression to differentiate with is x

      When the expression is computed

      Then the derivative expression is -<sin>(2x) * 2
