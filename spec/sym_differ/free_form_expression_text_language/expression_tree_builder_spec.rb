# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/expression_tree_builder"
require "sym_differ/free_form_expression_text_language/constant_token"
require "sym_differ/free_form_expression_text_language/variable_token"
require "sym_differ/free_form_expression_text_language/operator_token"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::ExpressionTreeBuilder do
  describe "#build" do
    subject(:build) { described_class.new.build(tokens) }

    context "when the tokens list is 1" do
      let(:tokens) { [constant_token(1)] }

      it "returns a Constant Expression 1" do
        expect(build).to have_attributes(value: 1)
      end
    end

    context "when the tokens list is x" do
      let(:tokens) { [variable_token("x")] }

      it "returns a Variable Expression x" do
        expect(build).to have_attributes(name: "x")
      end
    end

    context "when the tokens list is +" do
      let(:tokens) { [operator_token("+")] }

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::FreeFormExpressionTextLanguage::InvalidSyntaxError)
      end
    end

    context "when the tokens list is x + x" do
      let(:tokens) { [variable_token("x"), operator_token("+"), variable_token("x")] }

      it "returns a Sum Expression x + x" do
        expect(build).to have_attributes(
          expression_a: an_object_having_attributes(name: "x"),
          expression_b: an_object_having_attributes(name: "x")
        )
      end
    end

    context "when the tokens list is x +" do
      let(:tokens) { [variable_token("x"), operator_token("+")] }

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::FreeFormExpressionTextLanguage::InvalidSyntaxError)
      end
    end

    context "when the tokens list is x x" do
      let(:tokens) { [variable_token("x"), variable_token("x")] }

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::FreeFormExpressionTextLanguage::InvalidSyntaxError)
      end
    end

    context "when the tokens list is x - 1" do
      let(:tokens) { [variable_token("x"), operator_token("-"), constant_token(1)] }

      it "returns a Sum Expression x + x" do
        expect(build).to have_attributes(
          minuend: an_object_having_attributes(name: "x"),
          subtrahend: an_object_having_attributes(value: 1)
        )
      end
    end

    context "when the tokens list is --1" do
      let(:tokens) { [operator_token("-"), operator_token("-"), constant_token(1)] }

      it "returns a NegateExpression --1" do
        expect(build).to have_attributes(
          negated_expression: an_object_having_attributes(
            negated_expression: an_object_having_attributes(
              value: 1
            )
          )
        )
      end
    end

    context "when the tokens list is x + --1 (clarification)" do
      let(:tokens) do
        [variable_token("x"), operator_token("+"), operator_token("-"), operator_token("-"), constant_token(1)]
      end

      it "returns a SumExpression x, --1" do
        expect(build).to have_attributes(
          expression_a: an_object_having_attributes(name: "x"),
          expression_b: an_object_having_attributes(
            negated_expression: an_object_having_attributes(
              negated_expression: an_object_having_attributes(
                value: 1
              )
            )
          )
        )
      end
    end

    context "when the tokens list is empty" do
      let(:tokens) do
        []
      end

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::FreeFormExpressionTextLanguage::InvalidSyntaxError)
      end
    end

    define_method(:constant_token) do |value|
      SymDiffer::FreeFormExpressionTextLanguage::ConstantToken.new(value)
    end

    define_method(:variable_token) do |name|
      SymDiffer::FreeFormExpressionTextLanguage::VariableToken.new(name)
    end

    define_method(:operator_token) do |symbol|
      SymDiffer::FreeFormExpressionTextLanguage::OperatorToken.new(symbol)
    end
  end
end
