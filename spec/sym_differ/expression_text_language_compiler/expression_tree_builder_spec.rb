# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/expression_tree_builder"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::ExpressionTreeBuilder do
  describe "#build" do
    subject(:build) do
      described_class
        .new(SymDiffer::ExpressionFactory.new)
        .build(tokens)
    end

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
        expect { build }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::InvalidSyntaxError)
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
        expect { build }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::InvalidSyntaxError)
      end
    end

    context "when the tokens list is x x" do
      let(:tokens) { [variable_token("x"), variable_token("x")] }

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::InvalidSyntaxError)
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
        expect { build }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::InvalidSyntaxError)
      end
    end

    define_method(:constant_token) do |value|
      SymDiffer::ExpressionTextLanguageCompiler::ConstantToken.new(value)
    end

    define_method(:variable_token) do |name|
      SymDiffer::ExpressionTextLanguageCompiler::VariableToken.new(name)
    end

    define_method(:operator_token) do |symbol|
      SymDiffer::ExpressionTextLanguageCompiler::OperatorToken.new(symbol)
    end
  end
end
