@visualize_function @validate_expression
Feature: Visualize expression and derivative expression as SVG

  This feature file gives examples of the SVG images produced by the Visualize Expression And Derivative Expression process.

  If you just ran this test suite, or are seeing this text you're reading right now as part of a report (e.g., an HTML file), you can view the test artifacts that were produced as part of the text execution.
  - If you ran this test suite locally, at the time of writing, the files are stored in this repository's `features/test_artifacts` folder.

  See also:
  - The `Visualize expression and derivative expression` feature that produces the examples in this file.
  - The `Get Derivative Of Expression` feature to understand how the user requests the derivative of a function.

  Rule: As long as the rule is valid per expression rules, it can be visualized.

    Scenario: Visualizing image of 0 and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of 0
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_0_expression_and_derivative.svg

    Scenario: Visualizing image of 1 and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of 1
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_1_expression_and_derivative.svg

    Scenario: Visualizing image of 2 and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of 2
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_2_expression_and_derivative.svg

    Scenario: Visualizing the image of x and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of x
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_x_expression_and_derivative.svg

    Scenario: Visualizing the image of x * x and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of x * x
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_x_times_x_expression_and_derivative.svg

    Scenario: Visualizing the image of sine(x) and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of sine(x)
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_sine_x_expression_and_derivative.svg

    Scenario: Visualizing the image of sine(x * x) and its derivative.
      Given the image is requested of the expression and derivative of sine(x * x)
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_sine_x_square_x_and_derivative.svg

    Scenario: Visualizing the image of sine(x) - x and its derivative.
      Given the image is requested of the expression and derivative of sine(x) - x
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_sine_x_minus_x_and_derivative.svg

    Scenario: Visualizing the image of 2 * cosine(x) and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of 2 * cosine(x)
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_two_cosine_expression_and_derivative.svg

    Scenario: Visualizing the image of x * x * x and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of x * x * x
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_x_times_x_times_x_expression_and_derivative.svg

    Scenario: Visualizing the image of x * x * cosine(x) and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of x * x * cosine(x)
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_x_times_x_times_cosx_expression_and_derivative.svg

    Scenario: Visualizing the image of 3 / 2 and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of 3 / 2
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_3_over_2_expression_and_derivative.svg

    Scenario: Visualizing the image of 1 / x and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of 1 / x
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_1_over_x_expression_and_derivative.svg

    Scenario: Visualizing the image of 1 / (x - (28 / 3)) and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of 1 / (x - (28 / 3))
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_1_over_x_minus_38_thirds_expression_and_derivative.svg

    Scenario: Visualizing the image of 1 / sine(x) and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of 1 / sine(x)
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_1_over_sinex_expression_and_derivative.svg

    Scenario: Visualizing the image of sine(x) / x and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of sine(x) / x
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_sinex_over_x_expression_and_derivative.svg

    Scenario: Visualizing the image of (sine(x) + cosine(x)) / x and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of (sine(x) + cosine(x)) / x
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_sinex_p_cosine_x_over_x_expression_and_derivative.svg

    Scenario: Visualizing the image of (sine(x) * cosine(x)) / x and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of (sine(x) * cosine(x)) / x
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_sinex_t_cosine_x_over_x_expression_and_derivative.svg

    Scenario: Visualizing the image of x ^ 2 and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of x ^ 2
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_x_squared_expression_and_derivative.svg

    Scenario: Visualizing the image of 3 ^ x and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of 3 ^ x
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_3_raisedto_x_expression_and_derivative.svg

    Scenario: Visualizing the image of x ^ x and its derivative, with respect to x.
      Given the image is requested of the expression and derivative of x ^ x
      And the image is of the graphs with respect to, and of the derivative of the expression with respect to x

      When the image is requested

      Then the image is stored with filename: visualize_x_raisedto_x_expression_and_derivative.svg
