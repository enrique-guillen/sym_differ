# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/checkers/parens_token_checker"

require "sym_differ/expression_text_language_compiler/tokens/identifier_token"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Checkers::ParensTokenChecker do
  describe "#check" do
    subject(:check) { described_class.new.check(token) }

    context "when the token is (" do
      let(:token) { parens_token(:opening) }

      it "returns a precedence change" do
        expect(check).to include(
          successfully_handled_response(
            :post_opening_parenthesis,
            item_type: :precedence_change, new_precedence_change: 10
          )
        )
      end
    end

    context "when the token is )" do
      let(:token) { parens_token(:closing) }

      it "returns a precedence change" do
        expect(check).to include(
          successfully_handled_response(
            :post_closing_parenthesis,
            item_type: :precedence_change, new_precedence_change: -10
          )
        )
      end
    end

    context "when the token is x" do
      let(:token) { variable_token("x") }

      it "returns a precedence change" do
        expect(check).to include(handled: false)
      end
    end

    define_method(:successfully_handled_response) do |next_expected_token_type, stack_item|
      { handled: true, next_expected_token_type:, stack_item: }
    end

    define_method(:parens_token) do |type|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::ParensToken.new(type)
    end

    define_method(:variable_token) do |name|
      SymDiffer::ExpressionTextLanguageCompiler::Tokens::IdentifierToken.new(name)
    end
  end
end
