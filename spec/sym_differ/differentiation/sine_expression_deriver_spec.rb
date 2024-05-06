# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/sine_expression_deriver"

RSpec.describe SymDiffer::Differentiation::SineExpressionDeriver do
  describe "#derive" do
    subject(:derive) do
      described_class.new(expression_factory, differentiation_visitor).derive(expression)
    end

    before do
      allow(angle_expression).to receive(:accept).with(differentiation_visitor).and_return(angle_expression_derivative)
    end

    let(:expression_factory) { sym_differ_expression_factory }
    let(:differentiation_visitor) { double(:differentiation_visitor) }

    let(:expression) { sine_expression(angle_expression) }
    let(:angle_expression) { expression_test_double(:angle_expression) }
    let(:angle_expression_derivative) { expression_test_double(:angle_expression_derivative) }

    it "returns the expected derivative" do
      expect(derive).to be_same_as(
        multiplicate_expression(
          cosine_expression(angle_expression),
          angle_expression_derivative
        )
      )
    end
  end
end
