This is the compiler for the SymDiffer Expression Text Language. For the time being, the language is a copy of most
other languages of strings of mathematical expressions.

The goal of this module is to have a function, that takes a string created by the user representing a mathematical
expression, and transforms it into its abstract Expression tree (the root Expression object).

For example: The expression for `x + 1` is a sum, which can be described as a tree:
- a root node of type Sum, where
  - the A leaf is a node of type Variable, with name "x"
  - the B leaf is a node of type Constant, with value 1

The approach is to have a Facade [GoF Facade pattern] that takes the user's input string and returns the aformentioned
expression tree. Behind the facade, the input string goes through 3 stages:
- Tokenizers/token extractors that group & categorize sections of the user's strings into a smaller set of discrete
  tokens.
- An Expression Tree Builder scans the tokens and converts the tokens into a list of commands, called Evaluation Stack,
  with different precedence levels, which produce expressions when executed.
- An EvaluationStackReducer will scan the Evaluation Stack and execute all of the Commands [GoF Command pattern] in
  order of their precedence until all commands of all precedences have been executed.
