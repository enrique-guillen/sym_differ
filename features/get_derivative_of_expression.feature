@derive_function @simplify_expression @validate_expression
Feature: Get the symbolic derivative of a given expression.

  The derivative of a function `F` is a function `F'` that describes the rate of change of the value of the function `F`
  with respect to one of its parameters.

  The goal of this feature is to compute the derivative of a given function.

  The inputs consist of:
  - A string which contains the symbolic expression that defines the function to derive, e.g. `2x + 1`, `sine(x)`,
    `xy`, etc.
  - A string that specifies the character or name of the parameter of the function, e.g., `x`, `angle`, etc.

  The output is another string, a symbolic expression that defines the computed derivative function, e.g., `2`,
  `cosine(x)`, `y`, etc. The output is simplified so that it's reasonably compact (e.g., has a smaller number of terms).

  The list of rules is mostly centered around giving a general differentiation rule for each operation with arbitrary
  functions as parameters.

  Rule: A simple expression can be derived.

    Scenario: The user asks for the derivative of x, with respect to x.

  Rule: The expression and parameter must be valid.

  Scenario: The user asks for the derivative of "" + "", with respect to x.

    Scenario: The user asks for the derivative of 1, with respect to "" (no variable specified).

  Rule: The outputted expression is simplified.

    Scenario: The user asks for the derivative of x + x.

  Rule: The derivative of a constant is f'(x) = 0.

    Scenario: The user asks for the derivative of 0 with respect to x.

    Scenario: The user asks for the derivative of 1 with respect to x.

  Rule: The derivative of f(x) = x is f'(x) = 1.

    Scenario: The user asks for the derivative of x with respect to x.

  Rule: The derivative of f(x) = -a(x) is f'(x) = -a'(x).

    Scenario: The user asks for the derivative of -x with respect to x.

  Rule: The derivative of f(x) = a(x) + b(x) is f'(x) = a'(x) + b'(x).

    Scenario: The user asks for the derivative of x + 1 with respect to x.

    Scenario: The user asks for the derivative of x - x with respect to x.

    Scenario: The user asks for the derivative of x - x - x with respect to x.

  Rule: The derivative of f(x) = a(x) - b(x) is f'(x) = a'(x) - b'(x).

    Scenario: The user asks for the derivative of x - x - x with respect to x.

  Rule: The derivative of f(x) = a(x)b(x) is f'(x) = a'(x)b(x) + a(x)b'(x).

    Scenario: The user asks for the derivative of x * (x + x).

    Scenario: The user asks for the derivative of x * (2 * x).

  Rule: The derivative of f(x) = <e>x, where <e> is the Euler constant, is f'(x) = <e>^x.

    Scenario: The user asks for the derivative of <e> ^ x.

    Scenario: The user asks for the derivative of (<e> ^ x) + (<e> ^ x)

  Rule: The derivative of f(x) = <ln>(x), where <ln> is the natural logarithm function, is f'(x) = 1 / x.

    Scenario: The user asks for the derivative of <ln>(x).

    Scenario: The user asks for the derivative of 2 * <ln>(x).

  Rule: The derivative of f(x) = a(b(x)) is f'(x) = a'(b(x)) * b'(x).

    Scenario: The user asks for the derivative of <e> ^ (2 * x)

    Scenario: The user asks for the derivative of <ln>(x ^ 2)

  Rule: The function f(x) = a(x)^b(x) is equivalent to f(x) = e^(<ln>(a(x) ^ b(x))). Therefore, by the chain rule, the derivative of the function is f'(x) = e^(b(x)<ln>(a(x))) * (b'(x)<ln>(a(x)) + b(x)(a'(x) / a(x)))

    Scenario: The user asks for the derivative of x ^ (2 * x).

    Scenario: The user asks for the derivative of (2 * x) ^ (2 * x).

  Rule: The function f(x) = <sin>(x), where <sin> is the sine function, is f'(x) = <cos>(x).

    Scenario: The user asks for the derivative of <sin>(x).

    Scenario: The user asks for the derivative of <sin>(2 * x).

  Rule: The function f(x) = <cos>(x), where <cos> is the cosine function, is f'(x) = -<sine>(x).

    Scenario: The user asks for the derivative of <cos>(x).

    Scenario: The user asks for the derivative of <cos>(2 * x).
