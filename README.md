# SymDiffer
This repository is the core repository of the SymDiffer application. It implements the use cases of the SymDiffer
application and contains the implementation of its mathematical operations.

## Purpose and current state
This repository was created to showcase an approach to implementing a Symbolic Differentiation Program, akin to [the one
presented in the Structure and Interpretation of Computer Programs](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-16.html#%_sec_2.3.2),
implementing the set of derivative rules explained in most introductory calculus textbooks, developed in an incremental
& iterative fashion.

This repository now serves that purpose more or less, although the expression reduction module has a lot of room for
improvement (for example, the expression x + x + 1 + 1 will only be simplified to x + x + 2 and not something more
desirable, like 2x + 2). Improving it could make it a useful standalone feature but there are no plans at the moment to
do that -- feel free to make a fork of this repository to add that.

## Development instructions & commands
- There is a .ruby-version file that indicates with which Ruby version this project was developed. You can use `rbenv`
  or another method to install this Ruby version.
- Run `bundle install` to install all dependencies.
- To run the automated acceptance criteria tests, run `bundle exec cucumber`. `report.cucumber.html` is already
  git-ignored if you want to generate a report file in your local repository.
- To run RSpec tests: `bundle exec rspec spec component_tests`. The `spec/` folder contains typical unit tests whereas
  the `component_tests/` tests can test multiple units, as well as tests that are too slow to be written in a TDD
  fashion.
- `rubocop` and `reek` should be executed for static analysis.

## See also
- [sym_differ_rails](https://github.com/enrique-guillen/sym_differ_rails) &
  [sym_differ_vue](https://github.com/enrique-guillen/sym_differ_vue) for the Web interface.
- [sym_differ_cli](https://github.com/enrique-guillen/sym_differ_cli) for the CLI alternative.
