The goal of this module is to have a function, that takes the abstract tree-representation of a mathematical expression
of an function, and transforms it into its corresponding derivative expression that describes the rate of change of its
curve.

The approach is to leverage the Composite structure [see GoF Composite pattern] and implement Visitors that handle
differentiation for each differentiable expression.

[~/dev/differentiation.uml.png]
