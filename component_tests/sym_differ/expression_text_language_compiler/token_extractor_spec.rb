# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/token_extractor"

require "sym_differ/expression_text_language_compiler/tokens/identifier_token"
require "sym_differ/expression_text_language_compiler/tokens/constant_token"
require "sym_differ/expression_text_language_compiler/tokens/operator_token"

require "sym_differ/expression_text_language_compiler/unrecognized_token_error"
require "sym_differ/expression_text_language_compiler/empty_expression_text_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::TokenExtractor do
  describe "#parse" do
    subject(:parse) { described_class.new(token_extractors).parse(expression_text) }

    let(:token_extractors) do
      [
        SymDiffer::ExpressionTextLanguageCompiler::Extractors::NilTokenExtractor.new,
        SymDiffer::ExpressionTextLanguageCompiler::Extractors::OperatorTokenExtractor.new,
        SymDiffer::ExpressionTextLanguageCompiler::Extractors::IdentifierTokenExtractor.new,
        SymDiffer::ExpressionTextLanguageCompiler::Extractors::ConstantTokenExtractor.new
      ]
    end

    let(:variable_token_class) { SymDiffer::ExpressionTextLanguageCompiler::Tokens::IdentifierToken }
    let(:constant_token_class) { SymDiffer::ExpressionTextLanguageCompiler::Tokens::ConstantToken }
    let(:operator_token_class) { SymDiffer::ExpressionTextLanguageCompiler::Tokens::OperatorToken }

    context "when the expression text to parse is ''" do
      let(:expression_text) { "" }

      it "raises an error when given an empty string" do
        expect { parse }.to raise_error(a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::EmptyExpressionTextError))
      end
    end

    context "when the expression text to parse is 'x'" do
      let(:expression_text) { "x" }

      it "returns <VariableToken:x>" do
        tokens = parse

        expect(tokens).to have_attributes(size: 1)
        expect(tokens[0]).to be_a_kind_of(variable_token_class).and have_attributes(name: "x")
      end
    end

    context "when the expression text to parse is 'var'" do
      let(:expression_text) { "var" }

      it "returns <VariableToken:var>" do
        tokens = parse

        expect(tokens).to have_attributes(size: 1)
        expect(tokens[0]).to be_a_kind_of(variable_token_class).and have_attributes(name: "var")
      end
    end

    context "when the expression text to parse is '11'" do
      let(:expression_text) { "11" }

      it "returns <VariableToken:var>" do
        tokens = parse

        expect(tokens).to have_attributes(size: 1)
        expect(tokens[0]).to be_a_kind_of(constant_token_class).and have_attributes(value: 11)
      end
    end

    context "when the expression text to parse is '-1'" do
      let(:expression_text) { "-1" }

      it "returns <NegateToken>,<ConstantToken:1>" do
        tokens = parse

        expect(tokens).to have_attributes(size: 2)
        expect(tokens[0]).to be_a_kind_of(operator_token_class).and have_attributes(symbol: "-")
        expect(tokens[1]).to be_a_kind_of(constant_token_class).and have_attributes(value: 1)
      end
    end

    context "when the expression text to parse is '1+1'" do
      let(:expression_text) { "1+1" }

      it "returns <ConstantToken:1>,<SumToken>,<ConstantToken:1>" do
        tokens = parse

        expect(tokens).to have_attributes(size: 3)
        expect(tokens[0]).to be_a_kind_of(constant_token_class).and have_attributes(value: 1)
        expect(tokens[1]).to be_a_kind_of(operator_token_class).and have_attributes(symbol: "+")
        expect(tokens[2]).to be_a_kind_of(constant_token_class).and have_attributes(value: 1)
      end
    end

    context "when the expression text to parse is '1 + 1'" do
      let(:expression_text) { "1 + 1" }

      it "returns <ConstantToken:1>,<SumToken>,<ConstantToken:1>" do
        tokens = parse

        expect(tokens).to have_attributes(size: 3)
        expect(tokens[0]).to be_a_kind_of(constant_token_class).and have_attributes(value: 1)
        expect(tokens[1]).to be_a_kind_of(operator_token_class).and have_attributes(symbol: "+")
        expect(tokens[2]).to be_a_kind_of(constant_token_class).and have_attributes(value: 1)
      end
    end

    context "when the expression text to parse is '1\n  +\n  1\n'" do
      let(:expression_text) { <<~EXPRESSION }
        1
          +
          1
      EXPRESSION

      it "returns <ConstantToken:1>,<SumToken>,<ConstantToken:1>" do
        tokens = parse

        expect(tokens).to have_attributes(size: 3)
        expect(tokens[0]).to be_a_kind_of(constant_token_class).and have_attributes(value: 1)
        expect(tokens[1]).to be_a_kind_of(operator_token_class).and have_attributes(symbol: "+")
        expect(tokens[2]).to be_a_kind_of(constant_token_class).and have_attributes(value: 1)
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

    context "when the expression text to parse is '\\'" do
      let(:expression_text) { "\\" }

      it "raises an error referencing the unexpected symbol" do
        expect { parse }.to raise_error(
          a_kind_of(SymDiffer::ExpressionTextLanguageCompiler::UnrecognizedTokenError)
            .and(having_attributes(invalid_expression_text: "\\"))
        )
      end
    end

    context "when the expression text to parse is 'var+1'" do
      let(:expression_text) { "var+1" }

      it "returns <VariableToken:var>,<SumToken>,<ConstantToken:1>" do
        tokens = parse

        expect(tokens).to have_attributes(size: 3)
        expect(tokens[0]).to be_a_kind_of(variable_token_class).and have_attributes(name: "var")
        expect(tokens[1]).to be_a_kind_of(operator_token_class).and have_attributes(symbol: "+")
        expect(tokens[2]).to be_a_kind_of(constant_token_class).and have_attributes(value: 1)
      end
    end
  end
end
