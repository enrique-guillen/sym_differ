# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/expression_tree_builder"

require "sym_differ/free_form_expression_text_language/variable_token"
require "sym_differ/free_form_expression_text_language/constant_token"
require "sym_differ/free_form_expression_text_language/operator_token"

require "sym_differ/variable_expression"
require "sym_differ/constant_expression"
require "sym_differ/negate_expression"
require "sym_differ/sum_expression"
require "sym_differ/subtract_expression"

require "sym_differ/free_form_expression_text_language/invalid_syntax_error"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::ExpressionTreeBuilder do
  describe "#build" do
    subject(:build) { described_class.new.build(tokens) }

    let(:variable_token_class) { SymDiffer::FreeFormExpressionTextLanguage::VariableToken }
    let(:constant_token_class) { SymDiffer::FreeFormExpressionTextLanguage::ConstantToken }
    let(:operator_token_class) { SymDiffer::FreeFormExpressionTextLanguage::OperatorToken }

    context "when the tokens list is <VariableToken:var>" do
      let(:tokens) { [variable_token_class.new("var")] }

      it "returns a variable expression" do
        expression = build

        expect(expression).to be_a_kind_of(SymDiffer::VariableExpression).and having_attributes(name: "var")
      end
    end

    context "when the tokens list is <ConstantToken:12>" do
      let(:tokens) { [constant_token_class.new(12)] }

      it "returns a constant expression" do
        expression = build

        expect(expression).to be_a_kind_of(SymDiffer::ConstantExpression)
      end
    end

    context "when the tokens list is <OperatorToken:+>" do
      let(:tokens) { [operator_token_class.new("+")] }

      it "raises an error mentioning the syntax error" do
        expect { build }.to raise_error(a_kind_of(SymDiffer::FreeFormExpressionTextLanguage::InvalidSyntaxError))
      end
    end

    context "when the tokens list is <OperatorToken:-><ConstantToken:1>" do
      let(:tokens) { [operator_token_class.new("-"), constant_token_class.new(1)] }

      it "returns a constant expression" do
        expression = build

        expect(expression)
          .to be_a_kind_of(SymDiffer::NegateExpression)
          .and having_attributes(
            negated_expression: (
              a_kind_of(SymDiffer::ConstantExpression).and having_attributes(value: 1)
            )
          )
      end
    end

    context "when the tokens list is <ConstantToken:1><OperatorToken:+><ConstantToken:1>" do
      let(:tokens) { [constant_token_class.new(1), operator_token_class.new("+"), constant_token_class.new(1)] }

      it "returns a constant expression" do
        expression = build

        expect(expression)
          .to be_a_kind_of(SymDiffer::SumExpression)
          .and having_attributes(
            expression_a: (a_kind_of(SymDiffer::ConstantExpression).and having_attributes(value: 1)),
            expression_b: (a_kind_of(SymDiffer::ConstantExpression).and having_attributes(value: 1))
          )
      end
    end

    context "when the tokens list is <ConstantToken:1><OperatorToken:+>" do
      let(:tokens) { [constant_token_class.new(1), operator_token_class.new("+")] }

      it "raises an error mentioning the invalid expression end" do
        expect { build }.to raise_error(a_kind_of(SymDiffer::FreeFormExpressionTextLanguage::InvalidSyntaxError))
      end
    end

    context "when the tokens list is <ConstantToken:1><OperatorToken:+><OperatorToken:+>" do
      let(:tokens) { [constant_token_class.new(1), operator_token_class.new("+"), operator_token_class.new("+")] }

      it "raises an error mentioning the invalid expression end" do
        expect { build }.to raise_error(a_kind_of(SymDiffer::FreeFormExpressionTextLanguage::InvalidSyntaxError))
      end
    end

    context "when the tokens list is <OperatorToken:-><OperatorToken:+>" do
      let(:tokens) { [operator_token_class.new("-"), operator_token_class.new("+")] }

      it "raises an error mentioning the invalid expression end" do
        expect { build }.to raise_error(a_kind_of(SymDiffer::FreeFormExpressionTextLanguage::InvalidSyntaxError))
      end
    end

    context "when the tokens list is <VariableToken:x><ConstantToken:1>" do
      let(:tokens) { [variable_token_class.new("x"), constant_token_class.new(1)] }

      it "raises an error mentioning the invalid expression end" do
        expect { build }.to raise_error(a_kind_of(SymDiffer::FreeFormExpressionTextLanguage::InvalidSyntaxError))
      end
    end

    context "when the tokens list is <VariableToken:x><SubtractionToken><ConstantToken:1>" do
      let(:tokens) { [variable_token_class.new("x"), operator_token_class.new("-"), constant_token_class.new(1)] }

      let(:negation_token) { double(:negation_token) }

      before do
        allow(negation_token)
          .to receive(:next_expected_token_category)
          .and_return(:follow_up_to_negation_token)
      end

      it "returns a subtraction expression" do
        expression = build

        expect(expression)
          .to be_a_kind_of(SymDiffer::SubtractExpression)
          .and having_attributes(
            minuend: (
              a_kind_of(SymDiffer::VariableExpression).and having_attributes(name: "x")
            ),
            subtrahend: (
              a_kind_of(SymDiffer::ConstantExpression).and having_attributes(value: 1)
            )
          )
      end
    end
  end
end
