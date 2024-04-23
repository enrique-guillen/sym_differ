*When this README was created, the last commit of this module was `23f849ac7cce197171b253f8640bf380f0acb912`.*

# Definition
This is the compiler for the SymDiffer Expression Text Language.

For the time being, the language is a copy of most other languages of strings of mathematical expressions. It might
evolve in a different direction, or alternatives might spawn from this project, once this one implements the basic
operations most expression languages do.

# Goal
The goal of this module is to have a function, that takes a string created by the user representing a mathematical
expression, and transforms it into its abstract Expression tree (the root Expression object).

For example: The expression for `x + 1` is a sum, which can be described as a tree:
- a root node of type Sum, where
  - the A leaf is a node of type Variable, with name "x"
  - the B leaf is a node of type Constant, with value 1

# Approach
## Parser
This is a Facade that tokenizes the user's input string via the Token Extractor. The result is processed through the
Expression Tree Builder, which produces the final result: the abstract Expression tree.

## Tokenizer/Token Extractor
The token extractor reads the user's characters one at a time. Characters are grouped together according to their
meaning according to the language: a series of alphabetical characters represent a variable  -- which is stored as a
VariableToken in our system --, symbols such as `+` or `-` represent prefix or infix operators -- which are stored as
OperatorTokens in our system. The result of this scanning operation is a list of such tokens in the order they appear.

For example: the list of tokens in a string `var + 1` is `[VariableToken("var"), OperatorToken("+"), ConstantToken(1)]`

## Expression Tree Builder
Although a functional approach sounds desirable, because of TCO still not being the default in Ruby from what I can
tell, we have to settle for something that keeps stack size under control, or explicitly defines it in memory.

To build abstract Expression trees we settle for an explicit stack approach, where items are added to the stack as we
read the characters/tokens of the expression that the user inputed.

Expressions such as `x + 1`, have trees less trivial than expressions such as `1`, or `x`. To build those, we build a
"command an expression stack," pushing to it each time we scan each token, and then constantly checking if we can reduce
the stack at any point in time. For example, his is the evolution of the stack when the tokens for `x + 1` are read:

```
Pending tokens to read (initial state): [VariableToken(x), OperatorToken(+), ConstantToken(1)]
Command and expression stack (initial state): []

Next token: VariableToken(x)
Push Expression Variable(x) to stack: [Variable(x)]
Stack after reducing/applying operators: [Variable(x)] (no reductions were applied)

Next token: OperatorToken(+)
Push Command BuildSumCommand to stack: [Variable(x), BuildSumCommand]
Stack after reducing/applying operators: [Variable(x), BuildSumCommand] (no reductions were applied)

Next token: ConstantToken(1)
Push Expression Constant(1) to stack: [Variable(x), BuildSumCommand, Constant(1)]
Stack after reducing/applying operators: [Sum(Variable(x), Constant(1))] (1 reduction was applied: invoke
  BuildSumCommand with the other two arugments in the list)
```

The decision to push either an expression or a command is handled by `TokenChecker` objects, similar to a Chain of
Responsibilities. A list of Checkers are invoked until one handles the token. If a `TokenChecker` class in a list can
handle the next token we're reading, then that `TokenChecker` class will push its corresponding expression or command.
In the example above, a `VariableTokenChecker` class pushed `Variable(x)` into the stack, whereas `SumTokenChecker`
pushed the `BuildSumCommand`. When the stack's penultimate item was the `BuildSumExpressionCommand`, the command was
executed with the other two expression items `Variable(x)` and `Constant(1)` to produce the new expression
`Sum(Variable(x), Contant(1))`.

The Expression Tree Builder will eventually have logic that handles precedence of operators (e.g., `*` before `+`) but
the stack can be leveraged so that `Build<Operation>Command` stack items include information for arbitrating precedence.
