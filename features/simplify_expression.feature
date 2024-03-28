@simplify_expression
Feature: Compute a simplification for the expression.

  This file describes a set of rules that simplify the expression. What the rules mainly do is to replace superfluous
  items from expressions, such as `+ 0` in `x + 0`, or `1 *` in `1 * x`. It does not try to transform all expressions
  into a well-defined canonical form for the time being, and it won't expand polynomial expressions in case that it can
  result in a shorter expression.

  Scenario: The reduction of x is requested

  Scenario: The reduction of 0 + 0 is requested

  Scenario: The reduction of 1 + 0 is requested

  Scenario: The reduction of 3 + 2 - 2 is requested

  Scenario: The reduction of x - 1 - 2 is requested

  Scenario: The reduction of 0x is requested

  Scenario: The reduction of 1x is requested

  Scenario: The reduction of (1 + 0)x is requested.

  Scenario: The reduction of (1 + x)1 is requested.

  Scenario: The reduction of e^0 is requested.

  Scenario: The reduction of e^1 is requested.

  Scenario: The reduction of e^x is requested.
