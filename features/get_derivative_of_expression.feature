@derive_function @validate_expression
Feature: Get the symbolic derivative of a given expression.

  The derivative of a function `F` is a function `F'` that describes the rate of change of the value of the function `F` with respect to one of its parameters.

  The goal of this feature is to allow users to ask for the derivative of an expression they provide.

  The inputs consist of:
  - A string that ideally represents the function to derive, e.g. `2x + 1`, `sine(x)`, `xy`, etc.
  - A string that specifies the character or name of the parameter of the function, e.g., `x`, `angle`, etc.

  The output is another string, a symbolic expression that defines the computed derivative function, e.g., `2`, `cosine(x)`, `y`, etc. The output is simplified so that it's reasonably compact (e.g., has a smaller number of terms).

  The list of rules is mostly centered around giving a general differentiation rule for each operation with arbitrary functions as parameters.

  See also:
  - The `Compute the symbolic derivative of a given expression.` feature to understand how the derivative of a function is actually calculated.

  Rule: A simple expression can be derived.

    Scenario: The user asks for the derivative of x, with respect to x.
      Given the user wants the derivative of x
      And the user wants the derivative with respect to x

      When the user requests the derivative

      Then the operation is successful
      And the computed derivative is 1

  Rule: The expression and parameter must be valid.

    Scenario: The user asks for the derivative of +, with respect to x.
      Given the user wants the derivative of +
      And the user wants the derivative with respect to x

      When the user requests the derivative

      Then the operation is unsuccessful

    Scenario: The user asks for the derivative of 1, with respect to ~ (no variable specified).
      Given the user wants the derivative of 1
      And the user wants the derivative with respect to ~ (no variable specified)

      When the user requests the derivative

      Then the operation is unsuccessful

  Rule: The outputted expression is simplified.

    Scenario: The user asks for the derivative of x + x.
      Given the user wants the derivative of x + x
      And the user wants the derivative with respect to x

      When the user requests the derivative

      Then the operation is successful
      And the computed derivative is 2
