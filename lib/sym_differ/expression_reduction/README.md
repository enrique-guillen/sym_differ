The goal of this module is to have a function, that takes the abstract tree-representation of a mathematical expression
of an function, and returns an equivalent expression with superfluous terms removed.

The approach is to leverage the Composite structure [see GoF Composite pattern] and implement Visitors that apply the
appropriate reductions for each expression type.

Compare to [the Differentiation module's README](https://github.com/enrique-guillen/sym_differ/blob/main/lib/sym_differ/differentiation/README.md).
