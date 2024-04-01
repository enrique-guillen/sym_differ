# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_token_extractor"
require "sym_differ/unparseable_expression_text_error"

class VariableToken
  def initialize(name)
    @name = name
  end

  attr_reader :name
end

class ConstantToken
  def initialize(value)
    @value = value
  end

  attr_reader :value
end

class OperationToken
  def initialize(symbol)
    @symbol = symbol
  end

  attr_reader :symbol
end

RSpec.describe SymDiffer::FreeFormExpressionTextTokenExtractor do
  describe "#parse" do
    subject(:parse) { described_class.new.parse(expression_text) }

    context "when the expression text to parse is ''" do
      let(:expression_text) { "" }

      it "raises an error when given an empty string" do
        expect { parse }
          .to raise_error(
            a_kind_of(SymDiffer::UnparseableExpressionTextError)
              .and(having_attributes(message: "The expression can't be empty.", invalid_expression_text: ""))
          )
      end
    end

    context "when the expression text to parse is 'x'" do
      let(:expression_text) { "x" }

      it "returns <VariableToken:x>" do
        tokens = parse
        expect(tokens[0]).to be_a_kind_of(VariableToken).and have_attributes(name: "x")
      end
    end

    context "when the expression text to parse is 'var'" do
      let(:expression_text) { "var" }

      it "returns <VariableToken:var>" do
        tokens = parse
        expect(tokens[0]).to be_a_kind_of(VariableToken).and have_attributes(name: "var")
      end
    end

    context "when the expression text to parse is '11'" do
      let(:expression_text) { "11" }

      it "returns <VariableToken:var>" do
        tokens = parse

        expect(tokens[0]).to be_a_kind_of(ConstantToken).and have_attributes(value: 11)
      end
    end

    context "when the expression text to parse is '-1'" do
      let(:expression_text) { "-1" }

      it "returns <NegateToken>,<ConstantToken:1>" do
        tokens = parse

        expect(tokens[0]).to be_a_kind_of(OperationToken).and have_attributes(symbol: "-")
        expect(tokens[1]).to be_a_kind_of(ConstantToken).and have_attributes(value: 1)
      end
    end

    context "when the expression text to parse is '1+1'" do
      let(:expression_text) { "1+1" }

      it "returns <ConstantToken:1>,<SumToken>,<ConstantToken:1>" do
        tokens = parse

        expect(tokens[0]).to be_a_kind_of(ConstantToken).and have_attributes(value: 1)
        expect(tokens[1]).to be_a_kind_of(OperationToken).and have_attributes(symbol: "+")
        expect(tokens[2]).to be_a_kind_of(ConstantToken).and have_attributes(value: 1)
      end
    end

    context "when the expression text to parse is '1 + 1'" do
      let(:expression_text) { "1 + 1" }

      it "returns <ConstantToken:1>,<SumToken>,<ConstantToken:1>" do
        tokens = parse

        expect(tokens[0]).to be_a_kind_of(ConstantToken).and have_attributes(value: 1)
        expect(tokens[1]).to be_a_kind_of(OperationToken).and have_attributes(symbol: "+")
        expect(tokens[2]).to be_a_kind_of(ConstantToken).and have_attributes(value: 1)
      end
    end

    context "when the expression text to parse is '1\n  +\n  1'" do
      let(:expression_text) { <<~EXPRESSION }
        1
          +
          1
      EXPRESSION

      it "returns <ConstantToken:1>,<SumToken>,<ConstantToken:1>" do
        tokens = parse

        expect(tokens[0]).to be_a_kind_of(ConstantToken).and have_attributes(value: 1)
        expect(tokens[1]).to be_a_kind_of(OperationToken).and have_attributes(symbol: "+")
        expect(tokens[2]).to be_a_kind_of(ConstantToken).and have_attributes(value: 1)
      end
    end

    context "when the expression text to parse is '!'" do
      let(:expression_text) { "3!" }

      it "raises an error referencing the unexpected symbol" do
        expect { parse }
          .to raise_error(
            a_kind_of(SymDiffer::UnparseableExpressionTextError)
              .and(having_attributes(message: "A token in the expression started with unrecognized token '!'.",
                                     invalid_expression_text: "!"))
          )
      end
    end

    context "when the expression text to parse is '\\'" do
      let(:expression_text) { "\\" }

      it "raises an error referencing the unexpected symbol" do
        expect { parse }
          .to raise_error(
            a_kind_of(SymDiffer::UnparseableExpressionTextError)
              .and(having_attributes(message: "A token in the expression started with unrecognized token '\\'.",
                                     invalid_expression_text: "\\"))
          )
      end
    end
  end
end
