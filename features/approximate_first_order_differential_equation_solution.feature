@differential_equation
Feature: Numerical approximation of first order differential equation solution.

  This feature file goes into detail about how the numerical approximation is calculated. Currently, the strategy for
  calculating data is hardcoded to be the Runge-Kutta 4th order method.

  The domain of the returned approximation will be an arbitrary number of steps separated by an arbitrary gap, which
  currently is the range [initial_abscissa..initial_abscissa+10] divided into partitions of size 0.125.

  In this feature file we shouldn't be testing the entirety of the output, since it would make the file unwieldy to edit
  and read. Instead, just include a few key values of interest.

  See also:
  - `Get the first order approximation of a first order differential equation.` for the inputs provided to this
    functionality.

  Rule: As long as the parameters are valid, the approximation can be calculated.

    Scenario: The user requests the approximation of y' = x, y(0.0) = 1, y-var="y", t-var="x"
      Given the approximation is requested of the equation y' = x
      And the initial (t-var, y-var) coordinate of the approximation is (0.0, 0.0)
      And the y-variable name of the approximation is set to y
      And the t-variable name of the approximation is set to x

      When the approximation is requested

      Then the approximation operation is successful
      And the inital values of the approximation are:
      """
      0.000,0.0
      0.125,<to be defined>
      0.250,<to be defined>
      0.375,<to be defined>
      0.500,<to be defined>
      """

    Scenario: The user requests the approximation of y' = y, y(0.0) = 1, y-var="y", t-var="x"
      Given the approximation is requested of the equation y' = y
      And the initial (t-var, y-var) coordinate of the approximation is (0.0, 1.0)
      And the y-variable name of the approximation is set to y
      And the t-variable name of the approximation is set to x

      When the approximation is requested

      Then the approximation operation is successful
      And the inital values of the approximation are:
      """
      0.000,1.0
      0.125,<to be defined>
      0.250,<to be defined>
      0.375,<to be defined>
      0.500,<to be defined>
      """

    Scenario: The user requests the approximation of y' = x - y, y(0.0) = 1, y-var="y", t-var="x"
      Given the approximation is requested of the equation y' = y
      And the initial (t-var, y-var) coordinate of the approximation is (0.0, 1.0)
      And the y-variable name of the approximation is set to y
      And the t-variable name of the approximation is set to x

      When the approximation is requested

      Then the approximation operation is successful
      And the inital values of the approximation are:
      """
      0.000,1.0
      0.125,<to be defined>
      0.250,<to be defined>
      0.375,<to be defined>
      0.500,<to be defined>
      """

    Scenario: The user requests the approximation of y' = x * x + 1, y(0.0) = 0.0, y-var="y", t-var="x"
      Given the approximation is requested of the equation y' = y
      And the initial (t-var, y-var) coordinate of the approximation is (0.0, 0.0)
      And the y-variable name of the approximation is set to y
      And the t-variable name of the approximation is set to x

      When the approximation is requested

      Then the approximation operation is successful
      And the inital values of the approximation are:
      """
      0.000,0.0
      0.125,<to be defined>
      0.250,<to be defined>
      0.375,<to be defined>
      0.500,<to be defined>
      """

    Scenario: The user requests the approximation of y' = x * x + 1, y(0.0) = 1.0, y-var="y", t-var="x"
      Given the approximation is requested of the equation y' = y
      And the initial (t-var, y-var) coordinate of the approximation is (0.0, 1.0)
      And the y-variable name of the approximation is set to y
      And the t-variable name of the approximation is set to x

      When the approximation is requested

      Then the approximation operation is successful
      And the inital values of the approximation are:
      """
      0.000,1.0
      0.125,<to be defined>
      0.250,<to be defined>
      0.375,<to be defined>
      0.500,<to be defined>
      """
