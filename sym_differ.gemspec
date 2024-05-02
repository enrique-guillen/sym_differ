# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "sym_differ"
  spec.summary = "Toolkit for deriving symbolic expressions"
  spec.version = "1.0.0"
  spec.authors = ["The SymDifferCli contributors."]

  spec.files = %w[
    lib/sym_differ.rb"
    lib/sym_differ/get_derivative_of_expression_director.rb
    lib/sym_differ/derivative_of_expression_getter.rb
  ]

  spec.required_ruby_version = "~> 3.3.0"

  spec.metadata = { "rubygems_mfa_required" => "true" }
  spec.licenses = ["MIT"]
end
