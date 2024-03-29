# frozen_string_literal: true

require "spec_helper"
require "sym_differ/derivative_of_expression_getter"

RSpec.describe SymDiffer::DerivativeOfExpressionGetter do
  describe "#get" do
    subject(:get) do
      described_class
        .new(expression_text_parser, differentiation_visitor_builder, expression_reducer, expression_textifier)
        .get("x", "x")
    end

    before do
      allow(expression_text_parser)
        .to receive(:parse)
        .with("x")
        .and_return(parsed_expression)

      allow(differentiation_visitor_builder)
        .to receive(:build)
        .with("x")
        .and_return(differentiation_visitor)

      allow(differentiation_visitor)
        .to receive(:derive)
        .with(parsed_expression)
        .and_return(derivative_expression)

      allow(expression_reducer)
        .to receive(:reduce)
        .with(derivative_expression)
        .and_return(reduced_derivative_expression)

      allow(expression_textifier)
        .to receive(:textify)
        .with(reduced_derivative_expression)
        .and_return(textified_reduced_derivative_expression)
    end

    let(:expression_text_parser) { double(:expression_text_parser) }
    let(:differentiation_visitor_builder) { double(:differentiation_visitor_builder) }
    let(:differentiation_visitor) { double(:differentiation_visitor) }
    let(:expression_reducer) { double(:expression_reducer) }
    let(:expression_textifier) { double(:expression_textifier) }

    let(:parsed_expression) { double(:parsed_expression) }
    let(:derivative_expression) { double(:derivative_expression) }
    let(:reduced_derivative_expression) { double(:reduced_derivative_expression) }
    let(:textified_reduced_derivative_expression) { double(:textified_reduced_derivative_expression) }

    it "returns the reduced_derivative_expression" do
      expect(get).to have_attributes(successful?: true, derivative_expression: textified_reduced_derivative_expression)
    end
  end
end
