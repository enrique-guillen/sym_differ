# frozen_string_literal: true

require "spec_helper"
require "sym_differ/derivative_of_expression_getter"
require "sym_differ/invalid_variable_given_to_expression_parser_error"
require "sym_differ/unparseable_expression_text_error"

RSpec.describe SymDiffer::DerivativeOfExpressionGetter do
  describe "#get" do
    subject(:get) do
      described_class
        .new(expression_text_parser, deriver, expression_reducer, expression_stringifier)
        .get(expression_text, variable)
    end

    before { allow(expression_text_parser).to receive(:validate_variable) }

    let(:expression_text_parser) { double(:expression_text_parser) }
    let(:deriver) { double(:deriver) }
    let(:expression_reducer) { double(:expression_reducer) }
    let(:expression_stringifier) { double(:expression_stringifier) }

    let(:expression_text) { "x" }
    let(:variable) { "x" }

    context "when the variable is 'x'" do
      before do
        allow(expression_text_parser)
          .to receive(:parse)
          .with("x")
          .and_return(parsed_expression)

        allow(deriver)
          .to receive(:derive)
          .with(parsed_expression)
          .and_return(derivative_result)

        allow(expression_reducer)
          .to receive(:reduce)
          .with(derivative_result)
          .and_return(reduced_result)

        allow(expression_stringifier)
          .to receive(:stringify)
          .with(reduced_result)
          .and_return(textified_result)
      end

      let(:parsed_expression) { double(:parsed_expression) }
      let(:derivative_result) { double(:derivative_result) }
      let(:reduced_result) { double(:reduced_result) }
      let(:textified_result) { double(:textified_result) }

      it "returns the textified result" do
        expect(get).to have_attributes(derivative_expression: textified_result)
      end
    end
  end
end
