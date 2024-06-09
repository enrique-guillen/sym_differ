# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/parser"

require "sym_differ/expression_text_language_compiler/invalid_variable_given_to_expression_parser_error"
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
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::UnrecognizedTokenError)
            .and(having_attributes(invalid_expression_text: "!"))
        )
      end
    end

    context "when the expression text to parse is ''" do
      let(:expression_text) { "" }

      it "raises an error referencing the unexpected symbol" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::EmptyExpressionTextError)
        )
      end
    end

    context "when the expression text to parse is '+'" do
      let(:expression_text) { "+" }

      it "raises an error mentioning the syntax error" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::InvalidTokenTerminatedExpressionError)
        )
      end
    end

    context "when the expression text to parse is '-'" do
      let(:expression_text) { "-" }

      it "raises an error mentioning the syntax error" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::InvalidTokenTerminatedExpressionError)
        )
      end
    end

    context "when the expression text to parse is '1 + sine(x)'" do
      let(:expression_text) { "1 + sine(x)" }

      it "has the expected structure" do
        expression = parse

        expect(expression).to be_same_as(
          sum_expression(
            constant_expression(1),
            sine_expression(variable_expression("x"))
          )
        )
      end
    end

    context "when the expression text to parse is '1 + unrecognized(x)'" do
      let(:expression_text) { "1 + unrecognized(x)" }

      it "raises an error mentioning the syntax error" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::UnrecognizedFunctionNameError)
        )
      end
    end

    context "when the expression text to parse is '('" do
      let(:expression_text) { "(" }

      it "raises an error mentioning the syntax error" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::InvalidTokenTerminatedExpressionError)
        )
      end
    end

    context "when the expression text to parse is ')'" do
      let(:expression_text) { ")" }

      it "raises an error mentioning the syntax error" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::ImbalancedExpressionError)
        )
      end
    end

    context "when the expression text to parse is 'sine)'" do
      let(:expression_text) { "sine)" }

      it "raises an error mentioning the syntax error" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::ImbalancedExpressionError)
        )
      end
    end

    context "when the expression text to parse is '1 + (2)'" do
      let(:expression_text) { "1 + (2)" }

      it "returns a structure representing 1 + 2" do
        expression = parse

        expect(expression).to be_same_as(
          sum_expression(constant_expression(1), constant_expression(2))
        )
      end
    end

    context "when the expression text to parse is 'x - 1'" do
      let(:expression_text) { "x - 1" }

      it "returns a structure representing x - 1" do
        expression = parse

        expect(expression).to be_same_as(
          subtract_expression(variable_expression("x"), constant_expression(1))
        )
      end
    end

    context "when the expression text to parse is '--1'" do
      let(:expression_text) { "--1" }

      it "returns a structure representing -- 1" do
        expression = parse

        expect(expression).to be_same_as(
          negate_expression(negate_expression(constant_expression(1)))
        )
      end
    end

    context "when the expression text to parse is 'x + --1'" do
      let(:expression_text) { "x + --1" }

      it "returns a structure representing x + --1" do
        expression = parse

        expect(expression).to be_same_as(
          sum_expression(variable_expression("x"), negate_expression(negate_expression(constant_expression(1))))
        )
      end
    end

    context "when the expression text to parse is '1 - (2)'" do
      let(:expression_text) { "1 - (2)" }

      it "returns a structure representing 1 - 2" do
        expression = parse

        expect(expression).to be_same_as(
          subtract_expression(constant_expression(1), constant_expression(2))
        )
      end
    end

    context "when the expression text to parse is '1 * (2)'" do
      let(:expression_text) { "1 * (2)" }

      it "returns a structure representing 1 * 2" do
        expression = parse

        expect(expression).to be_same_as(
          multiplicate_expression(constant_expression(1), constant_expression(2))
        )
      end
    end

    context "when the expression text to parse is '(1) + 2'" do
      let(:expression_text) { "(1) + 2" }

      it "returns a structure representing 1 + 2" do
        expression = parse

        expect(expression).to be_same_as(
          sum_expression(constant_expression(1), constant_expression(2))
        )
      end
    end

    context "when the expression text to parse is '(sine(x) + 2)' (clarification)" do
      let(:expression_text) { "(sine(x) + 2)" }

      it "returns a structure representing sine(x) + 2" do
        expression = parse

        expect(expression).to be_same_as(
          sum_expression(sine_expression(variable_expression("x")), constant_expression(2))
        )
      end
    end

    context "when the expression text to parse is '(sine(x) * x) * 2' (clarification)" do
      let(:expression_text) { "(sine(x) * x) * 2" }

      it "returns a structure representing (sine(x) * x) * 2" do
        expression = parse

        expect(expression).to be_same_as(
          multiplicate_expression(
            multiplicate_expression(sine_expression(variable_expression("x")), variable_expression("x")),
            constant_expression(2)
          )
        )
      end
    end

    context "when the expression text to parse is 'sine(x) * (x * 2)' (clarification)" do
      let(:expression_text) { "sine(x) * (x * 2)" }

      it "returns a structure representing sine(x) * (x * 2)" do
        expression = parse

        expect(expression).to be_same_as(
          multiplicate_expression(
            sine_expression(variable_expression("x")),
            multiplicate_expression(variable_expression("x"), constant_expression(2))
          )
        )
      end
    end

    context "when the expression text to parse is '((1+2))'" do
      let(:expression_text) { "((1+2))" }

      it "returns a structure representing 1 + 2" do
        expression = parse

        expect(expression).to be_same_as(
          sum_expression(
            constant_expression(1),
            constant_expression(2)
          )
        )
      end
    end

    context "when the expression text to parse is '1/2'" do
      let(:expression_text) { "1/2" }

      it "returns a structure representing 1 / 2" do
        expression = parse

        expect(expression).to be_same_as(
          divide_expression(
            constant_expression(1),
            constant_expression(2)
          )
        )
      end
    end

    context "when the expression text to parse is '1*'" do
      let(:expression_text) { "1*" }

      it "raises InvalidSyntaxError" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::InvalidTokenTerminatedExpressionError)
        )
      end
    end

    context "when the expression text to parse is '1/'" do
      let(:expression_text) { "1/" }

      it "raises InvalidSyntaxError" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::InvalidTokenTerminatedExpressionError)
        )
      end
    end

    context "when the expression text to parse is 'x^2'" do
      let(:expression_text) { "x^2" }

      it "returns a structure representing x ^ 2" do
        expression = parse

        expect(expression).to be_same_as(
          exponentiate_expression(
            variable_expression("x"),
            constant_expression(2)
          )
        )
      end
    end

    context "when the expression text to parse is 'x^'" do
      let(:expression_text) { "x^" }

      it "raises InvalidSyntaxError" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::InvalidTokenTerminatedExpressionError)
        )
      end
    end

    context "when the expression text to parse is 'ln(x)'" do
      let(:expression_text) { "ln(x)" }

      it "returns a structure representing natural_logarithm(x)" do
        expression = parse

        expect(expression).to be_same_as(
          natural_logarithm_expression(variable_expression("x"))
        )
      end
    end

    context "when the expression text to parse is '~e'" do
      let(:expression_text) { "~e" }

      it "returns a structure representing euler_number_expression" do
        expression = parse

        expect(expression).to be_same_as(euler_number_expression)
      end
    end

    context "when the expression text to parse is 'ln(~e) + ~e' (clarification)" do
      let(:expression_text) { "ln(~e) + ~e" }

      it "returns a structure representing euler_number_expression" do
        expression = parse

        expect(expression).to be_same_as(
          sum_expression(
            natural_logarithm_expression(euler_number_expression),
            euler_number_expression
          )
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
        expect { validate_variable }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::InvalidVariableGivenToExpressionParserError)
        )
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
        expect { validate_variable }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::InvalidVariableGivenToExpressionParserError)
        )
      end
    end

    context "when the variable is ' c '" do
      let(:variable) { " c " }

      it "raises an error" do
        expect { validate_variable }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::InvalidVariableGivenToExpressionParserError)
        )
      end
    end
  end
end
