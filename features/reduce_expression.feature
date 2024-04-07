@reduce_expression
Feature: Compute a reduction for the expression.

  This feature file defines the rules for reducing an expression. It describes a set of rules that reduce an expression. Most rules simply ask for the removal of superfluous items from expressions, such as `+ 0` in `x + 0`, or `1 *` in `1 * x`. It does not try to transform all expressions into a well-defined canonical form for the time being, and it won't expand polynomial expressions in case that it can result in a shorter expression.

  Scenario: The reduction of x is requested

  Scenario: The reduction of 0 + 0 is requested

  Scenario: The reduction of 1 + 0 is requested

  Scenario: The reduction of 1 + 1 is requested
