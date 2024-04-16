@reduce_expression
Feature: Compute a reduction for the expression.

  This feature file defines the rules for reducing an expression. It describes a set of rules that reduce an expression. Most rules simply ask for the removal of superfluous items from expressions, such as `+ 0` in `x + 0`, or `1 *` in `1 * x`. It does not try to transform all expressions into a well-defined canonical form for the time being, and it won't expand polynomial expressions in case that it can result in a shorter expression.

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
