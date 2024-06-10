The goal of this module is to have a function, that takes the abstract tree-representation of a mathematical expression
of an function, and transforms it into its corresponding derivative expression that describes the rate of change of its
curve.

The approach is to leverage the Composite structure [see GoF Composite pattern] and implement Visitors that handle
differentiation for each differentiable expression. The following PlantUML diagram shows a few select Expression method and classes to illustrate the approach:

![differentation uml](https://github.com/enrique-guillen/sym_differ/assets/31013835/f0e5c13c-e572-459e-98b8-690c78ec0b38)
