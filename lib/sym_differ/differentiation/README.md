*When this README was created, the last commit of this module was `13dc984f0dbaacad4f855b88c0c5e9c5013922b2`.*

# Goal
The goal of this module is to have a function, that takes the abstract tree-representation of a mathematical expression,
and transforms it into its corresponding derivative expression that describes the rate of change of its curve.

# Approach
An Expression such as a sum or a subtraction, has nested expressions as part of their attributes of arbitrary types,
with the exception of leaf expressions (constants and variables). It also happens that each type of expression has a
corresponding derivative expression (with respect to a specific variable, e.g., x), sometimes requiring the recursive
application of getting the corresponding derivative expression for each nested expression.

We can therefore define a method that converts the input expression into its derivative counterpart, based on what
type of expression it is, and recursively applying the method if the definition of the derivative requires it.

[~/dev/differentiation.uml.png]

We can leverage the Visitor pattern to define (outside of the Expression hierarchy) differentiation methods for each
member of the Expression "subclasses." A DifferentiationVisitor class holds all those methods. The "visited" expressions
(SumExpression, etc.) only have to implement the correct `#accept` method.

To obtain the derivative of a given expression, the `#accept` method of the expression we want to derive is called with
an instance of the `DifferentiationVisitor` as a parameter, and that will end up dispatching the correct call to the
`DifferentiationVisitor` if all the subclasses of Expression implement the corresponding `#accept` function.

Each public method in the `DifferentiationVisitor` will define what the derivative is of the provided expression, and
each one of those public methods will receive the `Expression` that they are differentiating to aide in building the
correct derivative expression, including the ability to recursively call `#accept` on the nested elements to get the
derivative of nested expressions.
