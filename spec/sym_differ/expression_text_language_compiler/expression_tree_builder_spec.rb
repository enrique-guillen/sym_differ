# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/expression_tree_builder"

require "sym_differ/expression_factory"
require "sym_differ/expression_text_language_compiler/invalid_syntax_error"
require "sym_differ/expression_text_language_compiler/command_and_expression_stack_reducer"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::ExpressionTreeBuilder do
  describe "#build" do
    subject(:build) do
      described_class
        .new(expression_factory, command_and_expression_stack_reducer)
        .build(tokens)
    end

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    let(:command_and_expression_stack_reducer) do
      SymDiffer::ExpressionTextLanguageCompiler::CommandAndExpressionStackReducer.new
    end

    context "when the tokens list is 1" do
      let(:tokens) { [constant_token(1)] }

      it "returns a Constant Expression 1" do
        expect(build).to be_same_as(constant_expression(1))
      end
    end

    context "when the tokens list is x" do
      let(:tokens) { [variable_token("x")] }

      it "returns a Variable Expression x" do
        expect(build).to be_same_as(variable_expression("x"))
      end
    end

    context "when the tokens list is +" do
      let(:tokens) { [operator_token("+")] }

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::InvalidSyntaxError)
      end
    end

    context "when the tokens list is -" do
      let(:tokens) { [operator_token("-")] }

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::InvalidSyntaxError)
      end
    end

    context "when the tokens list is x + x" do
      let(:tokens) { [variable_token("x"), operator_token("+"), variable_token("x")] }

      it "returns a Sum Expression x + x" do
        expect(build).to be_same_as(
          sum_expression(variable_expression("x"), variable_expression("x"))
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
        expect(build).to be_same_as(
          subtract_expression(variable_expression("x"), constant_expression(1))
        )
      end
    end

    context "when the tokens list is --1" do
      let(:tokens) { [operator_token("-"), operator_token("-"), constant_token(1)] }

      it "returns a NegateExpression --1" do
        expect(build).to be_same_as(
          negate_expression(negate_expression(constant_expression(1)))
        )
      end
    end

    context "when the tokens list is x + --1 (clarification)" do
      let(:tokens) do
        [variable_token("x"), operator_token("+"), operator_token("-"), operator_token("-"), constant_token(1)]
      end

      it "returns a SumExpression x, --1" do
        expect(build).to be_same_as(
          sum_expression(
            variable_expression("x"),
            negate_expression(negate_expression(constant_expression(1)))
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

    context "when the tokens list is +x" do
      let(:tokens) { [operator_token("+"), variable_token("x")] }

      it "returns a PositiveExpression" do
        expect(build).to be_same_as(positive_expression(variable_expression("x")))
      end
    end

    context "when the tokens list is x * x" do
      let(:tokens) { [variable_token("x"), operator_token("*"), variable_token("x")] }

      it "returns a MultiplicateExpression" do
        expect(build).to be_same_as(
          multiplicate_expression(variable_expression("x"), variable_expression("x"))
        )
      end
    end

    context "when the tokens list is 1 + x * x" do
      let(:tokens) do
        [constant_token(1), operator_token("+"), variable_token("x"), operator_token("*"), variable_token("x")]
      end

      it "returns a SumExpression" do
        expect(build).to be_same_as(
          sum_expression(
            constant_expression(1),
            multiplicate_expression(variable_expression("x"), variable_expression("x"))
          )
        )
      end
    end

    context "when the tokens list is 1 + x * x + 1 (clarification)" do
      let(:tokens) do
        [constant_token(1),
         operator_token("+"),
         variable_token("x"),
         operator_token("*"),
         variable_token("x"),
         operator_token("+"),
         constant_token(1)]
      end

      it "returns a SumExpression" do
        expect(build).to be_same_as(
          sum_expression(
            sum_expression(constant_expression(1),
                           multiplicate_expression(variable_expression("x"), variable_expression("x"))),
            constant_expression(1)
          )
        )
      end
    end

    context "when the tokens list is x * + x" do
      let(:tokens) do
        [variable_token("x"), operator_token("*"), operator_token("+"), variable_token("x")]
      end

      it "returns a MultiplicateExpression" do
        expect(build).to be_same_as(
          multiplicate_expression(
            variable_expression("x"),
            positive_expression(variable_expression("x"))
          )
        )
      end
    end

    define_method(:constant_token) do |value|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::ConstantToken.new(value)
    end

    define_method(:variable_token) do |name|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::VariableToken.new(name)
    end

    define_method(:operator_token) do |symbol|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::OperatorToken.new(symbol)
    end
  end
end
