# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/parser"

require "sym_differ/invalid_variable_given_to_expression_parser_error"
require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Parser do
  let(:parser) { described_class.new(expression_factory) }

  let(:expression_factory) { SymDiffer::ExpressionFactory.new }

  describe "#parse" do
    subject(:parse) do
      parser.parse(expression_text)
    end

    context "when the expression is x + x" do
      let(:expression_text) { "x + x" }

      it "has the expected structure" do
        expression = parse

        expect(expression).to be_same_as(
          sum_expression(
            variable_expression("x"),
            variable_expression("x")
          )
        )
      end
    end

    context "when the expression text to parse is '3!'" do
      let(:expression_text) { "3!" }

      it "raises an error referencing the unexpected symbol" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::UnparseableExpressionTextError).and(
            having_attributes(cause: a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::UnrecognizedTokenError)
              .and(having_attributes(invalid_expression_text: "!")))
          )
        )
      end
    end

    context "when the expression text to parse is ''" do
      let(:expression_text) { "" }

      it "raises an error referencing the unexpected symbol" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::UnparseableExpressionTextError).and(
            having_attributes(
              cause: a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::EmptyExpressionTextError)
            )
          )
        )
      end
    end

    context "when the expression text to parse is '+'" do
      let(:expression_text) { "+" }

      it "raises an error mentioning the syntax error" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::UnparseableExpressionTextError)
            .and(having_attributes(cause: a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::InvalidSyntaxError)))
        )
      end
    end
  end

  describe "#validate_variable" do
    subject(:validate_variable) do
      parser.validate_variable(variable)
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

  define_method(:variable_expression) do |name|
    expression_factory.create_variable_expression(name)
  end

  define_method(:sum_expression) do |expression_a, expression_b|
    expression_factory.create_sum_expression(expression_a, expression_b)
  end
end
