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

      Then some of the values of the approximation are:
      """
      0.0,   0.0
      0.125, 0.023437499999999997
      0.5,   0.18750000000000003
      1.0,   0.6250000000000002
      5.0,   13.125
      10.0,  51.250000000000014
      """

    Scenario: The user requests the approximation of y' = y, y(0.0) = 1, y-var="y", t-var="x"
      Given the approximation is requested of the equation y' = y
      And the initial (t-var, y-var) coordinate of the approximation is (0.0, 1.0)
      And the y-variable name of the approximation is set to y
      And the t-variable name of the approximation is set to x

      When the approximation is requested

      Then some of the values of the approximation are:
      """
      0.0,   1.0
      0.125, 1.1271974540051117
      0.5,   1.6143585443928121
      1.0,   2.6061535098540802
      5.0,   120.22643420198703
      10.0,  14454.395480924717
      """

    Scenario: The user requests the approximation of y' = x - y, y(0.0) = 1, y-var="y", t-var="x"
      Given the approximation is requested of the equation y' = x - y
      And the initial (t-var, y-var) coordinate of the approximation is (0.0, 1.0)
      And the y-variable name of the approximation is set to y
      And the t-variable name of the approximation is set to x

      When the approximation is requested

      Then some of the values of the approximation are:
      """
      0.0,   1.0
      0.125, 0.9002054238025052
      0.5,   0.7533717903344526
      1.0,   0.8114082952744177
      5.0,   4.179936698450573
      10.0,  9.170322644855332
      """

    Scenario: The user requests the approximation of y' = x + 1, y(0.0) = 0.0, y-var="y", t-var="x"
      Given the approximation is requested of the equation y' = x + 1
      And the initial (t-var, y-var) coordinate of the approximation is (0.0, 0.0)
      And the y-variable name of the approximation is set to y
      And the t-variable name of the approximation is set to x

      When the approximation is requested

      Then some of the values of the approximation are:
      """
      0.0,   0.0
      0.125, 0.14843749999999997
      0.5,   0.6874999999999998
      1.0,   1.625
      5.0,   18.124999999999996
      10.0,  61.25
      """

    Scenario: The user requests the approximation of y' = x * x + 1, y(0.0) = 1.0, y-var="y", t-var="x"
      Given the approximation is requested of the equation y' = x * x + 1
      And the initial (t-var, y-var) coordinate of the approximation is (0.0, 1.0)
      And the y-variable name of the approximation is set to y
      And the t-variable name of the approximation is set to x

      When the approximation is requested

      Then some of the values of the approximation are:
      """
      0.0,   1.0
      0.125, 1.129557291666667
      0.5,   1.580729166666667
      1.0,   2.473958333333333
      5.0,   50.86979166666666
      10.0,  356.98958333333337
      """

    Scenario: The user requests the approximation of y' = 1/x, y(1.0) = 0.0, y-var="y", t-var="x"
      Given the approximation is requested of the equation y' = 1 / x
      And the initial (t-var, y-var) coordinate of the approximation is (1.0, 0.0)
      And the y-variable name of the approximation is set to y
      And the t-variable name of the approximation is set to x

      When the approximation is requested

      Then some of the values of the approximation are:
      """
      1.0,   0.0
      1.125, 0.1053606237816764
      1.5,   0.3677250226678144
      2.0,   0.6359890570578819
      6.0,   1.6945960356436387
      11.0,  2.2914121075932474
      """

    Scenario: The user requests the approximation of y' = 1/x, y(-10.0) = 2.3, y-var="y", t-var="x"
      Given the approximation is requested of the equation y' = 1 / x
      And the initial (t-var, y-var) coordinate of the approximation is (-10.0, 2.3)
      And the y-variable name of the approximation is set to y
      And the t-variable name of the approximation is set to x

      When the approximation is requested

      Then some of the values of the approximation are:
      """
      -10.0,  2.3,
      -9.875, 2.2872609742197745
      -9.5,   2.2480402610569348
      -9.0,   2.193232024545803
      -5.0,   1.5941137928159246
      -0.125, :undefined
       0.0,   :undefined
      """

    Scenario: The user requests the approximation of y' = ln(x), y(-9.0) = 0.0, y-var="x", t-var="t"
      Given the approximation is requested of the equation y' = ln(x)
      And the initial (t-var, y-var) coordinate of the approximation is (-9.0, 0.0)
      And the y-variable name of the approximation is set to x
      And the t-variable name of the approximation is set to t

      When the approximation is requested

      Then some of the values of the approximation are:
      """
      -9.0,   0.0
      -8.875, :undefined
      -8.5,   :undefined
      -8.0,   :undefined
      -4.0,   :undefined
       1.0,   :undefined
      """

    Scenario: The user requests the approximation of y' = 1/x, y(-9.0) = 2.3, y-var="y", t-var="x"
      Given the approximation is requested of the equation y' = 1/x
      And the initial (t-var, y-var) coordinate of the approximation is (-9.0, 2.3)
      And the y-variable name of the approximation is set to y
      And the t-variable name of the approximation is set to x

      When the approximation is requested

      Then some of the values of the approximation are:
      """
      -9.0,   2.3
      -8.875, 2.2858153650032587
      -8.5,   2.2420127423282525
      -8.0,   2.1804548492999603
      -4.0,   1.4713073252713422
       1.0,   :undefined
      """
