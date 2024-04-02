# frozen_string_literal: true

require "spec_helper"
require "sym_differ/derivative_of_expression_getter"
require "sym_differ/invalid_variable_given_to_expression_parser_error"
require "sym_differ/unparseable_expression_text_error"

RSpec.describe SymDiffer::DerivativeOfExpressionGetter do
  describe "#get" do
    subject(:get) do
      described_class
        .new(expression_text_parser, differentiation_visitor_builder, expression_reducer, expression_textifier_visitor)
        .get(expression_text, variable)
    end

    before { allow(expression_text_parser).to receive(:validate_variable) }

    let(:expression_text_parser) { double(:expression_text_parser) }
    let(:differentiation_visitor_builder) { double(:differentiation_visitor_builder) }
    let(:expression_reducer) { double(:expression_reducer) }
    let(:expression_textifier_visitor) { double(:expression_textifier_visitor) }

    let(:expression_text) { "x" }
    let(:variable) { "x" }

    context "when the variable is 'x'" do
      before do
        allow(expression_text_parser)
          .to receive(:parse)
          .with("x")
          .and_return(parsed_expression)

        allow(differentiation_visitor_builder)
          .to receive(:build)
          .with("x")
          .and_return(differentiation_visitor)

        allow(parsed_expression)
          .to receive(:accept)
          .with(differentiation_visitor)
          .and_return(derivative_result)

        allow(expression_reducer)
          .to receive(:reduce)
          .with(derivative_result)
          .and_return(reduced_result)

        allow(reduced_result)
          .to receive(:accept)
          .with(expression_textifier_visitor)
          .and_return(textified_result)
      end

      let(:differentiation_visitor) { double(:differentiation_visitor) }

      let(:parsed_expression) { double(:parsed_expression) }
      let(:derivative_result) { double(:derivative_result) }
      let(:reduced_result) { double(:reduced_result) }
      let(:textified_result) { double(:textified_result) }

      it "returns the textified result" do
        expect(get).to have_attributes(successful?: true, derivative_expression: textified_result)
      end
    end

    context "when the variable is not valid for the parser and an exception is thrown" do
      before do
        allow(expression_text_parser)
          .to receive(:validate_variable)
          .with("invalid-variable-example")
          .and_raise(causing_exception)
      end

      let(:variable) { "invalid-variable-example" }

      let(:causing_exception) do
        SymDiffer::InvalidVariableGivenToExpressionParserError.new(
          "Invalid variable name 'invalid-variable-example', please follow the parser's instructions.",
          "invalid-variable-name"
        )
      end

      it "returns an application failure response" do
        expect(get).to have_attributes(successful?: false, message: "See #cause for details.", cause: causing_exception)
      end
    end

    context "when the parsing operation is invalid and an exception is thrown" do
      before do
        allow(expression_text_parser)
          .to receive(:parse)
          .with(expression_text)
          .and_raise(causing_exception)
      end

      let(:expression_text) { "x +/-" }

      let(:causing_exception) do
        SymDiffer::UnparseableExpressionTextError.new(
          "Invalid expression text 'x +/-', please follow the parser's instructions.",
          "x +/-"
        )
      end

      it "returns an application failure response" do
        expect(get).to have_attributes(successful?: false, message: "See #cause for details.", cause: causing_exception)
      end
    end
  end
end
