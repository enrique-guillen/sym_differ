@visualize_function @validate_expression
Feature: Illustrate Differential Equation Approximation as SVG

  This feature file gives examples of the SVG images produced by the Illustrate Differential Equation Approximation process.

  If you just ran this test suite, or are seeing this text you're reading right now as part of a report (e.g., an HTML file), you can view the test artifacts that were produced as part of the text execution.
  - If you ran this test suite locally, at the time of writing, the files are stored in this repository's `features/test_artifacts` folder.

  See also:
  - The `Illustrate Differential Equation Approximation` feature that produces the examples in this file.
  - The `Numerical approximation of first order differential equation solution.` feature to understand how the user requests the approximation of a solution to the provided equation.

  Rule: As long as the parameters are valid, the approximation's illustration can be generated.

    Scenario: The user requests the approximation of y' = 0, y(0.0) = 1, y-var="y", t-var="x"
      Given the approximation illustration is requested of the equation y' = 0
      And the approximation illustration's initial (t-var, y-var) coordinate of the approximation is (0.0, 1.0)
      And the approximation illustration's y-variable name of the approximation is set to y
      And the approximation illustration's t-variable name of the approximation is set to x

      When the illustration is requested

      Then the image is stored with filename: dy_equals_0_iv_0__1.svg

    Scenario: The user requests the approximation of y' = 1, y(0.0) = 0, y-var="y", t-var="x"
      Given the approximation illustration is requested of the equation y' = 1
      And the approximation illustration's initial (t-var, y-var) coordinate of the approximation is (0.0, 0.0)
      And the approximation illustration's y-variable name of the approximation is set to y
      And the approximation illustration's t-variable name of the approximation is set to x

      When the illustration is requested

      Then the image is stored with filename: dy_equals_1_iv_0__1.svg

    Scenario: The user requests the approximation of y' = x, y(0.0) = 0, y-var="y", t-var="x"
      Given the approximation illustration is requested of the equation y' = x
      And the approximation illustration's initial (t-var, y-var) coordinate of the approximation is (0.0, 0.0)
      And the approximation illustration's y-variable name of the approximation is set to y
      And the approximation illustration's t-variable name of the approximation is set to x

      When the illustration is requested

      Then the image is stored with filename: dy_equals_x_iv_0__1.svg

    Scenario: The user requests the approximation of y' = y, y(0.0) = 1, y-var="y", t-var="x"
      Given the approximation illustration is requested of the equation y' = y
      And the approximation illustration's initial (t-var, y-var) coordinate of the approximation is (0.0, 1.0)
      And the approximation illustration's y-variable name of the approximation is set to y
      And the approximation illustration's t-variable name of the approximation is set to x

      When the illustration is requested

      Then the image is stored with filename: dy_equals_y_iv_0__0.svg

    Scenario: The user requests the approximation of y' = x - y, y(0.0) = 1, y-var="y", t-var="x"
      Given the approximation illustration is requested of the equation y' = x - y
      And the approximation illustration's initial (t-var, y-var) coordinate of the approximation is (0.0, 1.0)
      And the approximation illustration's y-variable name of the approximation is set to y
      And the approximation illustration's t-variable name of the approximation is set to x

      When the illustration is requested

      Then the image is stored with filename: dy_equals_x_minus_y_iv_0__1.svg

    Scenario: The user requests the approximation of y' = x + 1, y(0.0) = 0.0, y-var="y", t-var="x"
      Given the approximation illustration is requested of the equation y' = x + 1
      And the approximation illustration's initial (t-var, y-var) coordinate of the approximation is (0.0, 0.0)
      And the approximation illustration's y-variable name of the approximation is set to y
      And the approximation illustration's t-variable name of the approximation is set to x

      When the illustration is requested

      Then the image is stored with filename: dy_equals_x_plus_y_iv_0__0.svg

    Scenario: The user requests the approximation of y' = x * x + 1, y(0.0) = 1.0, y-var="y", t-var="x"
      Given the approximation illustration is requested of the equation y' = x * x + 1
      And the approximation illustration's initial (t-var, y-var) coordinate of the approximation is (0.0, 1.0)
      And the approximation illustration's y-variable name of the approximation is set to y
      And the approximation illustration's t-variable name of the approximation is set to x

      When the illustration is requested

      Then the image is stored with filename: dy_equals_x_times_x_plus_1_iv_0__0.svg

    Scenario: The user requests the approximation of y' = +1, y(0.0) = 0, y-var="y", t-var="x"
      Given the approximation illustration is requested of the equation y' = +1
      And the approximation illustration's initial (t-var, y-var) coordinate of the approximation is (0.0, 0.0)
      And the approximation illustration's y-variable name of the approximation is set to y
      And the approximation illustration's t-variable name of the approximation is set to x

      When the illustration is requested

      Then the image is stored with filename: dy_equals_p1_iv_0__1.svg
