Gem::Specification.new do |spec|
  spec.name        = 'sym_differ'
  spec.version     = '1.0.0'
  spec.licenses    = ['MIT']
  spec.summary     = "Toolkit for deriving symbolic expressions"
  spec.files       = ["lib/sym_differ.rb"]
  spec.authors    =  ["Enrique Guillen"]

  spec.add_development_dependency "cucumber", "~> 9.2.0"
  spec.add_development_dependency "rspec", "~> 3.13.0"
  spec.add_development_dependency "rubocop", "~> 1.62.1"
  spec.add_development_dependency "rubocop-rspec", "~> 1.62.1"
  spec.add_development_dependency "rubocop-performance", "~> 1.20.2"
end
