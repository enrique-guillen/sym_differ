# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/evaluation_stack_itemifiers/special_constant_itemifier"

require "sym_differ/expression_text_language_compiler/tokens/special_named_constant_token"
require "sym_differ/expression_text_language_compiler/tokens/identifier_token"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::EvaluationStackItemifiers::SpecialConstantItemifier do
  describe "#check" do
    subject(:check) { described_class.new(expression_factory).check(token) }

    let(:expression_factory) { sym_differ_expression_factory }

    context "when the provided token is e" do
      let(:token) { special_named_constant_token("e") }

      it "returns an expression and sets expression location as rightmost" do
        expect(check).to include(
          successfully_handled_response(
            :post_constant_token_checkers,
            expression_stack_item(1, same_expression_as(euler_number_expression))
          )
        )
      end
    end

    context "when the provided token is avar" do
      pending "to define behavior when an unrecognized name is provided as a special named constant"
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

    define_method(:special_named_constant_token) do |value|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::SpecialNamedConstantToken.new(value)
    end

    define_method(:identifier_token) do |name|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::IdentifierToken.new(name)
    end
  end
end
