# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/expression_tree_builder"

require "sym_differ/expression_factory"
require "sym_differ/expression_text_language_compiler/invalid_syntax_error"
require "sym_differ/expression_text_language_compiler/command_and_expression_stack_reducer"

require "sym_differ/expression_text_language_compiler/checkers/constant_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/identifier_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/subtraction_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/sum_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/multiplication_token_checker"
require "sym_differ/expression_text_language_compiler/checkers/parens_token_checker"

require "sym_differ/expression_text_language_compiler/tokens/parens_token"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::ExpressionTreeBuilder do
  describe "#build" do
    subject(:build) do
      described_class
        .new(command_and_expression_stack_reducer,
             checkers_by_role,
             %i[post_sum_token_checkers post_subtraction_token_checkers post_opening_parenthesis])
        .build(tokens)
    end

    let(:command_and_expression_stack_reducer) do
      SymDiffer::ExpressionTextLanguageCompiler::CommandAndExpressionStackReducer.new
    end

    let(:checkers_by_role) do
      {
        initial_token_checkers: [
          constant_token_checker,
          identifier_token_checker,
          subtraction_token_checker,
          sum_token_checker
        ],
        post_constant_token_checkers: [
          subtraction_token_checker,
          sum_token_checker,
          multiplication_token_checker,
          parens_token_checker
        ],
        post_identifier_token_checkers: [
          subtraction_token_checker,
          sum_token_checker,
          multiplication_token_checker,
          parens_token_checker
        ],
        post_multiplication_token_checkers: [
          constant_token_checker,
          identifier_token_checker,
          sum_token_checker,
          subtraction_token_checker
        ],
        post_sum_token_checkers: [
          constant_token_checker,
          identifier_token_checker,
          subtraction_token_checker,
          sum_token_checker
        ],
        post_subtraction_token_checkers: [
          constant_token_checker,
          identifier_token_checker,
          subtraction_token_checker,
          sum_token_checker
        ],
        post_opening_parenthesis: [
          identifier_token_checker,
          constant_token_checker,
          subtraction_token_checker,
          sum_token_checker
        ],
        post_closing_parenthesis: [
          subtraction_token_checker,
          sum_token_checker,
          multiplication_token_checker,
          parens_token_checker
        ]
      }.freeze
    end

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    let(:constant_token_checker) do
      SymDiffer::ExpressionTextLanguageCompiler::Checkers::ConstantTokenChecker.new(expression_factory)
    end

    let(:identifier_token_checker) do
      SymDiffer::ExpressionTextLanguageCompiler::Checkers::IdentifierTokenChecker.new(expression_factory)
    end

    let(:sum_token_checker) do
      SymDiffer::ExpressionTextLanguageCompiler::Checkers::SumTokenChecker.new(expression_factory)
    end

    let(:subtraction_token_checker) do
      SymDiffer::ExpressionTextLanguageCompiler::Checkers::SubtractionTokenChecker.new(expression_factory)
    end

    let(:multiplication_token_checker) do
      SymDiffer::ExpressionTextLanguageCompiler::Checkers::MultiplicationTokenChecker.new(expression_factory)
    end

    let(:parens_token_checker) do
      SymDiffer::ExpressionTextLanguageCompiler::Checkers::ParensTokenChecker.new
    end

    context "when the tokens list is 1" do
      let(:tokens) { [constant_token(1)] }

      it "returns a Constant Expression 1" do
        expect(build).to be_same_as(constant_expression(1))
      end
    end

    context "when the tokens list is x" do
      let(:tokens) { [identifier_token("x")] }

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
      let(:tokens) { [identifier_token("x"), operator_token("+"), identifier_token("x")] }

      it "returns a Sum Expression x + x" do
        expect(build).to be_same_as(
          sum_expression(variable_expression("x"), variable_expression("x"))
        )
      end
    end

    context "when the tokens list is x +" do
      let(:tokens) { [identifier_token("x"), operator_token("+")] }

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::InvalidSyntaxError)
      end
    end

    context "when the tokens list is x x" do
      let(:tokens) { [identifier_token("x"), identifier_token("x")] }

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::InvalidSyntaxError)
      end
    end

    context "when the tokens list is x - 1" do
      let(:tokens) { [identifier_token("x"), operator_token("-"), constant_token(1)] }

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
        [identifier_token("x"), operator_token("+"), operator_token("-"), operator_token("-"), constant_token(1)]
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
      let(:tokens) { [operator_token("+"), identifier_token("x")] }

      it "returns a PositiveExpression" do
        expect(build).to be_same_as(positive_expression(variable_expression("x")))
      end
    end

    context "when the tokens list is x * x" do
      let(:tokens) { [identifier_token("x"), operator_token("*"), identifier_token("x")] }

      it "returns a MultiplicateExpression" do
        expect(build).to be_same_as(
          multiplicate_expression(variable_expression("x"), variable_expression("x"))
        )
      end
    end

    context "when the tokens list is 1 + x * x" do
      let(:tokens) do
        [constant_token(1), operator_token("+"), identifier_token("x"), operator_token("*"), identifier_token("x")]
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
         identifier_token("x"),
         operator_token("*"),
         identifier_token("x"),
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
        [identifier_token("x"), operator_token("*"), operator_token("+"), identifier_token("x")]
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

    context "when the tokens list is sine(x)" do
      let(:tokens) do
        [identifier_token("sine"), parens_token(:opening), identifier_token("x"), parens_token(:closing)]
      end

      it "returns a SineExpression" do
        expect(build).to be_same_as(
          sine_expression(variable_expression("x"))
        )
      end
    end

    context "when the tokens list is sine(1 + sine(x))" do
      let(:tokens) do
        [
          identifier_token("sine"), # 1
          parens_token(:opening), # 1
          constant_token(1), # 2
          operator_token("+"), # 2
          identifier_token("sine"), # 2
          parens_token(:opening), # 2
          identifier_token("x"), # 3
          parens_token(:closing), # 2
          parens_token(:closing) # 1
        ]
      end

      it "returns a SineExpression" do
        expect(build).to be_same_as(
          sine_expression(
            sum_expression(constant_expression(1), sine_expression(variable_expression("x")))
          )
        )
      end
    end

    context "when the tokens list is sine)" do
      let(:tokens) do
        [identifier_token("sine"), parens_token(:closing)]
      end

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::InvalidSyntaxError)
      end
    end

    define_method(:constant_token) do |value|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::ConstantToken.new(value)
    end

    define_method(:identifier_token) do |name|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::IdentifierToken.new(name)
    end

    define_method(:operator_token) do |symbol|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::OperatorToken.new(symbol)
    end

    define_method(:parens_token) do |type|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::ParensToken.new(type)
    end
  end
end
