@visualize_function @validate_expression
Feature: Illustrate Differential Equation Approximation

  The goal of this feature is to show the user an image with the graphs of the approximation to a solution for the given expression in f'=f(y, y) form.

  See also:
  - The `Get the first order approximation of a first order differential equation.` feature to understand how the user requests the numerical approximation to the solution.

  Rule: A simple equation's approximation can be visualized.

    Scenario: The user requests the illustration to the approximation of y' = x, y(0.0) = 1, y-var="y", t-var="x"
      Given the user wants the approximation illustration of the equation y_function' = y
      And the user sets the approximation illustration's initial (t-var, y-var) coordinate to (0.0, 1.0)
      And the user sets the approximation illustration's y-variable name to y
      And the user sets the approximation illustration's t-variable name to x

      When the user requests the approximation's illustration

      Then the approximation's illustration is retrieved successfully

  Rule: The expression and parameter must be valid.

    Scenario: The user requests the approximation of y_function' = ~empty~, y(0.0) = 1.0, y-var="y", t-var="x"
      Given the user wants the approximation illustration of the equation y_function' = ~empty~
      And the user sets the approximation illustration's initial (t-var, y-var) coordinate to (0.0, 1.0)
      And the user sets the approximation illustration's y-variable name to y
      And the user sets the approximation illustration's t-variable name to x

      When the user requests the approximation's illustration

      Then the approximation's illustration is not retrieved successfully

    Scenario: The user requests the approximation of y_function' = y, y(0.0) = 1.0, y-var="123invalid", t-var="x"
      Given the user wants the approximation illustration of the equation y_function' = y
      And the user sets the approximation illustration's initial (t-var, y-var) coordinate to (0.0, 1.0)
      And the user sets the approximation illustration's y-variable name to 123invalid
      And the user sets the approximation illustration's t-variable name to x

      When the user requests the approximation's illustration

      Then the approximation's illustration is not retrieved successfully

    Scenario: The user requests the approximation of y_function' = y, y(0.0) = 1.0, y-var="y", t-var="123invalid"
      Given the user wants the approximation illustration of the equation y_function' = y
      And the user sets the approximation illustration's initial (t-var, y-var) coordinate to (0.0, 1.0)
      And the user sets the approximation illustration's y-variable name to x
      And the user sets the approximation illustration's t-variable name to 123invalid

      When the user requests the approximation's illustration

      Then the approximation's illustration is not retrieved successfully

  Rule: The y-variable name, and t-variable name, may be omitted, and will default to "y" & "t" respectively.

    Scenario: The user requests the approximation of y_function' = y, y(0.0) = 1.0, y-var=~empty~, t-var=~empty~
      Given the user wants the approximation illustration of the equation y_function' = y
      And the user sets the approximation illustration's initial (t-var, y-var) coordinate to (0.0, 1.0)
      And the user sets the approximation illustration's y-variable name to ~empty~
      And the user sets the approximation illustration's t-variable name to ~empty~

      When the user requests the approximation's illustration

      Then the approximation's illustration is retrieved successfully
