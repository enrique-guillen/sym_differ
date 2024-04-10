# frozen_string_literal: true

require "spec_helper"
require "sym_differ/get_derivative_of_expression_director"

RSpec.describe SymDiffer::GetDerivativeOfExpressionDirector do
  describe "#calculate_derivative" do
    subject(:calculate_derivative) { described_class.new.calculate_derivative("x + x", "x") }

    it { is_expected.to have_attributes(derivative_expression: "2") }
  end
end
