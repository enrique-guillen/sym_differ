# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/checkers/constant_token_checker"

require "sym_differ/expression_text_language_compiler/tokens/constant_token"
require "sym_differ/expression_text_language_compiler/tokens/identifier_token"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Checkers::ConstantTokenChecker do
  describe "#check" do
    subject(:check) { described_class.new(expression_factory).check(token) }

    let(:expression_factory) { sym_differ_expression_factory }

    context "when the provided token is 1" do
      let(:token) { constant_token(1) }

      it "returns an expression and sets expression location as rightmost" do
        expect(check).to include(
          successfully_handled_response(
            :post_constant_token_checkers,
            expression_stack_item(1, same_expression_as(constant_expression(1)))
          )
        )
      end
    end

    context "when the provided token is x" do
      let(:token) { identifier_token("x") }

      it { is_expected.to eq(handled: false) }
    end

    define_method(:successfully_handled_response) do |next_expected_token_type, stack_item|
      { handled: true, next_expected_token_type:, stack_item: }
    end

    define_method(:expression_stack_item) do |precedence, value|
      { item_type: :expression, precedence:, value: }
    end

    define_method(:constant_token) do |value|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::ConstantToken.new(value)
    end

    define_method(:identifier_token) do |name|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::IdentifierToken.new(name)
    end
  end
end
