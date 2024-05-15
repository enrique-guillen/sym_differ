@differential_equation
Feature: Get the first order approximation of a first order differential equation.

  This feature allows the user to obtain an approximation of a solution to a given first order differential equation.
  The expression that must be provided is the right hand side of the differential equation in "y'=f(y, t)" form.

  The name of the functions and variables can be valid identifier names and not just "y" and "t". Parameters have to be
  provided specifying the alternative names however.

  See also:
  - `Numerical approximation of first order differential equation solution.` for more details on the approximation.

  Rule: A simple approximation can be calculated.

    Scenario: The user requests the approximation of y' = y, y(0) = 1, y-var="y", t-var="x"
      Given the user wants the approximation of the equation y' = y
      And the user sets the initial (t-var, y-var) coordinate is (0, 1)
      And the user sets the y-variable name to y
      And the user sets the t-variable name to x

      When the user requests the approximation

      Then the approximation operation is successful
      And the inital values of the approximation are:
      """
      0.000,1
      0.125,<to be defined>
      0.250,<to be defined>
      0.375,<to be defined>
      0.500,<to be defined>
      """

  Rule: The expression, y-variable name, t-variable name, and initial ordinate value must be valid, if all provided.

    Scenario: The user requests the approximation of y' = ~empty~, y(0) = 1, y-var="y", t-var="x"
      Given the user wants the approximation of the equation y' = ~empty~
      And the user sets the initial (t-var, y-var) coordinate is (0, 1)
      And the user sets the y-variable name to y
      And the user sets the t-variable name to x

      When the user requests the approximation

      Then the approximation operation is unsuccessful

    Scenario: The user requests the approximation of y' = y, y(~empty~) = 1, y-var="y", t-var="x"
      Given the user wants the approximation of the equation y' = y
      And the user sets the initial (t-var, y-var) coordinate is (~empty~, 1)
      And the user sets the y-variable name to y
      And the user sets the t-variable name to x

      When the user requests the approximation

      Then the approximation operation is unsuccessful

    Scenario: The user requests the approximation of y' = y, y(0) = ~empty~, y-var="y", t-var="x"
      Given the user wants the approximation of the equation y' = y
      And the user sets the initial (t-var, y-var) coordinate is (0, ~empty~)
      And the user sets the y-variable name to y
      And the user sets the t-variable name to x

      When the user requests the approximation

      Then the approximation operation is unsuccessful

    Scenario: The user requests the approximation of y' = y, y(0) = 1, y-var="123invalid", t-var="x"
      Given the user wants the approximation of the equation y' = y
      And the user sets the initial (t-var, y-var) coordinate is (0, 1)
      And the user sets the y-variable name to 123invalid
      And the user sets the t-variable name to x

      When the user requests the approximation

      Then the approximation operation is unsuccessful

    Scenario: The user requests the approximation of y' = y, y(0) = 1, y-var="y", t-var="123invalid"
      Given the user wants the approximation of the equation y' = y
      And the user sets the initial (t-var, y-var) coordinate is (0, 1)
      And the user sets the y-variable name to x
      And the user sets the t-variable name to 123invalid

      When the user requests the approximation

      Then the approximation operation is unsuccessful

  Rule: The y-variable name, and t-variable name, may be omitted, and will default to "y" & "t" respectively.

    Scenario: The user requests the approximation of y' = y, y(0) = 1, y-var=~empty~, t-var=~empty~
      Given the user wants the approximation of the equation y' = y
      And the user sets the initial (t-var, y-var) coordinate is (0, 1)
      And the user sets the y-variable name to ~empty~
      And the user sets the t-variable name to ~empty~

      When the user requests the approximation

      Then the approximation operation is successful
      And the inital values of the approximation are:
      """
      0.000,1
      0.125,<to be defined>
      0.250,<to be defined>
      0.375,<to be defined>
      0.500,<to be defined>
      """
