@reduce_expression
Feature: Compute a reduction for the expression.

  This feature file defines the rules for reducing an expression. It describes a set of rules that reduce an expression, which is used throughout the system for "simplifying" expressions.

  Most rules simply ask for the removal of superfluous items from expressions, such as `+ 0` in `x + 0`, or `1 *` in `1 * x`. It does not try to transform all expressions into a well-defined canonical form for the time being, and it won't expand polynomial expressions in case that it can result in a shorter expression.

  Scenario: The reduction of x is requested
    Given the expression to reduce is x
    When the expression is reduced
    Then the result is x

  Scenario: The reduction of 0 + 0 is requested
    Given the expression to reduce is 0 + 0
    When the expression is reduced
    Then the result is 0

  Scenario: The reduction of 1 + 0 is requested
    Given the expression to reduce is 1 + 0
    When the expression is reduced
    Then the result is 1

  Scenario: The reduction of 1 + 1 is requested
    Given the expression to reduce is 1 + 1
    When the expression is reduced
    Then the result is 2

  Scenario: The reduction of 3 + 2 - 2 is requested
    Given the expression to reduce is 3 + 2 - 2
    When the expression is reduced
    Then the result is 3

  Scenario: The reduction of x - 1 - 2 is requested
    Given the expression to reduce is x - 1 - 2
    When the expression is reduced
    Then the result is x - 3

  Scenario: The reduction of ++2 + ++1 + ++x is requested
    Given the expression to reduce is ++2 + ++1 + ++x
    When the expression is reduced
    Then the result is x + 3

  Scenario: The reduction of x * 2 is requested
    Given the expression to reduce is x * 2
    When the expression is reduced
    Then the result is 2 * x

  Scenario: The reduction of x * 2 is requested
    Given the expression to reduce is x * 2
    When the expression is reduced
    Then the result is 2 * x

  Scenario: The reduction of x * -1 is requested
    Given the expression to reduce is x * -1
    When the expression is reduced
    Then the result is -1 * x
    And (@wip) the result is -x

  Scenario: The reduction of -1 * -1 is requested
    Given the expression to reduce is -1 * -1
    When the expression is reduced
    Then the result is 1

  Scenario: The reduction of x * x is requested
    Given the expression to reduce is x * x
    When the expression is reduced
    Then the result is x * x
    And (@wip) the result is x ^ 2

  Scenario: The reduction of 0 * x is requested
    Given the expression to reduce is 0 * x
    When the expression is reduced
    Then the result is 0

  Scenario: The reduction of --1 * x is requested
    Given the expression to reduce is --1 * x
    When the expression is reduced
    Then the result is x

  Scenario: The reduction of x / 1 is requested
    Given the expression to reduce is x / 1
    When the expression is reduced
    Then the result is x

  Scenario: The reduction of 0 / 1 is requested
    Given the expression to reduce is 0 / 1
    When the expression is reduced
    Then the result is 0

  Scenario: The reduction of x / x is requested
    Given the expression to reduce is x / x
    When the expression is reduced
    Then the result is 1

  Scenario: The reduction of 2 / 4 is requested
    Given the expression to reduce is 2 / 4
    When the expression is reduced
    Then the result is 2 / 4
    And (@wip) the result is 1 / 2

  Scenario: The reduction of 1 ^ 0 is requested
    Given the expression to reduce is 1 ^ 0
    When the expression is reduced
    Then the result is 1

  Scenario: The reduction of 2 ^ 0 is requested
    Given the expression to reduce is 2 ^ 0
    When the expression is reduced
    Then the result is 1

  Scenario: The reduction of 0 ^ 0 is requested
    Given the expression to reduce is 0 ^ 0
    When the expression is reduced
    Then the result is 1

  Scenario: The reduction of 0 ^ 1 is requested
    Given the expression to reduce is 0 ^ 1
    When the expression is reduced
    Then the result is 0

  Scenario: The reduction of 0 ^ 2 is requested
    Given the expression to reduce is 0 ^ 2
    When the expression is reduced
    Then the result is 0

  Scenario: The reduction of ln(~e) is requested
    Given the expression to reduce is ln(~e)
    When the expression is reduced
    Then the result is 1

  Scenario: The reduction of ln(1) is requested
    Given the expression to reduce is ln(1)
    When the expression is reduced
    Then the result is 0

  Scenario: The reduction of ln(x*y) is requested
    Given the expression to reduce is ln(x*y)
    When the expression is reduced
    Then the result is ln(x) + ln(y)

  Scenario: The reduction of ln(x*~e) is requested
    Given the expression to reduce is ln(x*~e)
    When the expression is reduced
    Then the result is ln(x) + 1

  Scenario: The reduction of ln(x^y) is requested
    Given the expression to reduce is ln(x^y)
    When the expression is reduced
    Then the result is y * ln(x)

  Scenario: The reduction of ln(~e^x) is requested
    Given the expression to reduce is ln(~e^x)
    When the expression is reduced
    Then the result is x

  Scenario: The reduction of ln(x/y) is requested
    Given the expression to reduce is ln(x / y)
    When the expression is reduced
    Then the result is ln(x / y)
    And (@wip) the result is ln(x) - ln(y)
