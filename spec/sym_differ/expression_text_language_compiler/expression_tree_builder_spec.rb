# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/expression_tree_builder"

require "sym_differ/expression_factory"
require "sym_differ/expression_text_language_compiler/invalid_syntax_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::ExpressionTreeBuilder do
  describe "#build" do
    subject(:build) do
      described_class
        .new(expression_factory)
        .build(tokens)
    end

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

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
      SymDiffer::ExpressionTextLanguageCompiler::ConstantToken.new(value)
    end

    define_method(:variable_token) do |name|
      SymDiffer::ExpressionTextLanguageCompiler::VariableToken.new(name)
    end

    define_method(:operator_token) do |symbol|
      SymDiffer::ExpressionTextLanguageCompiler::OperatorToken.new(symbol)
    end

    define_method(:constant_expression) do |value|
      expression_factory.create_constant_expression(value)
    end

    define_method(:variable_expression) do |name|
      expression_factory.create_variable_expression(name)
    end

    define_method(:sum_expression) do |expression_a, expression_b|
      expression_factory.create_sum_expression(expression_a, expression_b)
    end

    define_method(:subtract_expression) do |expression_a, expression_b|
      expression_factory.create_subtract_expression(expression_a, expression_b)
    end

    define_method(:negate_expression) do |negated_expression|
      expression_factory.create_negate_expression(negated_expression)
    end

    define_method(:positive_expression) do |summand|
      expression_factory.create_positive_expression(summand)
    end

    define_method(:multiplicate_expression) do |multiplicand, multiplier|
      expression_factory.create_multiplicate_expression(multiplicand, multiplier)
    end
  end
end
