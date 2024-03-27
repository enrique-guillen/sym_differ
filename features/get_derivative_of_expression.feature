Feature: Get the symbolic derivative of a given expression.

  The derivative of a function `F` is a function `F'` that describes the rate of change of the value of the function `F`
  with respect to one of its parameters.

  The goal of this feature is to compute the derivative of a given function.

  The inputs consist of:
  - A string which contains the symbolic representation of the expression that defines the function to derive,
    e.g. `2x + 1`, `sine(x)`, `xy`, etc.
  - A string that specifies the character or name of the parameter of the function, e.g., `x`, `angle`, etc.

  The output is another string, a symbolic representation of the expression that defines the computed derivative
  function, e.g., `2`, `cosine(x)`, `y`, etc. The output is simplified so that it's reasonably compact (e.g., has a
  smaller number of terms).

  Rule: A simple expression can be derived.

    Scenario: The user asks for the derivative of `x`, `x`

  Rule: The expression and parameter must be valid.

    Scenario: The user asks for the derivative of ` + `, `x`

    Scenario: The user asks for the derivative of `1`, ``

  Rule: The outputted expression is simplified.

    Scenario: The user asks for the derivative of `x + x`
