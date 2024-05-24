@visualize_function @validate_expression
Feature: Visualize expression and derivative expression

  The goal of this feature is to show the user an image with the graphs of an expression and its derivative.

  See also:
  - The `Get Derivative Of Expression` feature to understand how the user requests the derivative of a function.

  Rule: A simple expression and its derivative can be visualized.

    Scenario: The user asks for the image of x and its derivative, with respect to x.
      Given the user wants the image of the expression and derivative of x
      And the user wants the image with respect to x

      When the user requests the image

      Then the image is retrieved successfully

  Rule: The expression and parameter must be valid.

    Scenario: The user asks for the image of + and its derivative with respect to x.
      Given the user wants the image of the expression and derivative of +
      And the user wants the image with respect to x

      When the user requests the image

      Then the image is not retrieved successfully

    Scenario: The user asks for the image of 1 and its derivative, with respect to ~ (no variable specified).
      Given the user wants the image of the expression and derivative of 1
      And the user wants the image with respect to ~ (no variable specified)

      When the user requests the image

      Then the image is not retrieved successfully

  Rule: The outputted expression is stored.

    Scenario: The user asks for the image of sine(x * x) and its derivative.
      Given the user wants the image of the expression and derivative of sine(x * x)
      And the user wants the image with respect to x

      When the user requests the image

      Then the image is retrieved successfully
