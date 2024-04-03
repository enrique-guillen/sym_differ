# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/parser"
require "sym_differ/invalid_variable_given_to_expression_parser_error"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::Parser do
  describe "#parse" do
    subject(:parse) do
      described_class.new.parse("x + x")
    end

    it "has the expected structure" do
      expression = parse

      expect(expression).to have_attributes(
        expression_a: an_object_having_attributes(name: "x"),
        expression_b: an_object_having_attributes(name: "x")
      )
    end
  end

  describe "#validate_variable" do
    subject(:validate_variable) do
      described_class.new.validate_variable(variable)
    end

    context "when the variable is empty" do
      let(:variable) { "" }

      it "raises an error" do
        expect { validate_variable }.to raise_error(a_kind_of(SymDiffer::InvalidVariableGivenToExpressionParserError))
      end
    end

    context "when the variable is x" do
      let(:variable) { "x" }

      it "raises an error" do
        expect { validate_variable }.not_to raise_error
      end
    end

    context "when the variable is ' '" do
      let(:variable) { " " }

      it "raises an error" do
        expect { validate_variable }.to raise_error(a_kind_of(SymDiffer::InvalidVariableGivenToExpressionParserError))
      end
    end

    context "when the variable is ' c '" do
      let(:variable) { " c " }

      it "raises an error" do
        expect { validate_variable }.to raise_error(a_kind_of(SymDiffer::InvalidVariableGivenToExpressionParserError))
      end
    end
  end
end
