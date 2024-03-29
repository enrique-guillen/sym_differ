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
        .and_return(derivative_result)

      allow(expression_reducer)
        .to receive(:reduce)
        .with(derivative_result)
        .and_return(reduced_result)

      allow(expression_textifier)
        .to receive(:textify)
        .with(reduced_result)
        .and_return(textified_result)
    end

    let(:expression_text_parser) { double(:expression_text_parser) }
    let(:differentiation_visitor_builder) { double(:differentiation_visitor_builder) }
    let(:differentiation_visitor) { double(:differentiation_visitor) }
    let(:expression_reducer) { double(:expression_reducer) }
    let(:expression_textifier) { double(:expression_textifier) }

    let(:parsed_expression) { double(:parsed_expression) }
    let(:derivative_result) { double(:derivative_result) }
    let(:reduced_result) { double(:reduced_result) }
    let(:textified_result) { double(:textified_result) }

    it "returns the textified result" do
      expect(get).to have_attributes(successful?: true, derivative_expression: textified_result)
    end
  end
end
