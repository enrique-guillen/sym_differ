# frozen_string_literal: true

module Support
  module SymDifferDoubleBuilder
    def expression_test_double(name)
      test_double = double(name)
      allow(test_double).to receive(:same_as?).with(test_double).and_return(true)
      test_double
    end
  end
end
