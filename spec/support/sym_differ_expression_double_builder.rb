# frozen_string_literal: true

module Support
  # Creates test doubles that are "interchangeable" with normal members of the SymDiffer::Expressions class hierarchy.
  module SymDifferDoubleBuilder
    def expression_test_double(name)
      test_double = double(name)
      allow(test_double).to receive(:same_as?).and_return(false)
      allow(test_double).to receive(:same_as?).with(test_double).and_return(true)
      test_double
    end
  end
end
