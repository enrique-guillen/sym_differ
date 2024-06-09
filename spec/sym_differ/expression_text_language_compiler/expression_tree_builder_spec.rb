# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/expression_tree_builder"

require "sym_differ/expression_text_language_compiler/invalid_syntax_error"
require "sym_differ/expression_text_language_compiler/invalid_token_terminated_expression_error"
require "sym_differ/expression_text_language_compiler/imbalanced_expression_error"
require "sym_differ/expression_text_language_compiler/expected_token_type_not_found_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::ExpressionTreeBuilder do
  describe "#build" do
    subject(:build) do
      described_class
        .new(command_and_expression_stack_reducer,
             checkers_by_role,
             %i[post_frobulator_token_checkers post_open_parenthesis_checkers])
        .build(tokens)
    end

    before do
      allow(foo_token_checker).to receive(:check).and_return(handled: false)
      allow(frobulator_token_checker).to receive(:check).and_return(handled: false)
      allow(parenthesis_token_checker).to receive(:check).and_return(handled: false)

      map_token_checker_response(
        foo_token_checker,
        from: foo_token,
        stack_item: expression_stack_item(foo_expression, 2), next_expected_token_type: :post_foo_token_checkers
      )

      map_token_checker_response(
        frobulator_token_checker,
        from: frobulator_token,
        stack_item: command_stack_item(nil, 2), next_expected_token_type: :post_frobulator_token_checkers
      )

      map_token_checker_response(
        frobulator_token_checker, from: frobulator_token,
                                  stack_item: command_stack_item(nil, 2),
                                  next_expected_token_type: :post_frobulator_token_checkers
      )

      map_token_checker_response(
        parenthesis_token_checker,
        from: open_parens_token,
        stack_item: stack_item(:precedence_change, nil, nil, 3),
        next_expected_token_type: :post_open_parenthesis_checkers
      )

      map_token_checker_response(
        parenthesis_token_checker,
        from: close_parens_token,
        stack_item: stack_item(:precedence_change, nil, nil, -3),
        next_expected_token_type: :post_close_parenthesis_checkers
      )
    end

    let(:expression_factory) { sym_differ_expression_factory }

    let(:command_and_expression_stack_reducer) do
      double(:command_and_expression_stack_reducer)
    end

    let(:checkers_by_role) do
      {
        initial_token_checkers: [foo_token_checker, frobulator_token_checker, parenthesis_token_checker],
        post_foo_token_checkers: [frobulator_token_checker, parenthesis_token_checker],
        post_frobulator_token_checkers: [foo_token_checker, frobulator_token_checker, parenthesis_token_checker],
        post_open_parenthesis_checkers: [foo_token_checker, frobulator_token_checker, parenthesis_token_checker],
        post_close_parenthesis_checkers: [parenthesis_token_checker, frobulator_token_checker]
      }.freeze
    end

    let(:foo_token_checker) { double(:foo_token_checker) }
    let(:frobulator_token_checker) { double(:frobulator_token_checker) }
    let(:parenthesis_token_checker) { double(:parenthesis_token_checker) }

    let(:frobulator_token) { double(:frobulator_token) }
    let(:open_parens_token) { double(:open_parens_token) }
    let(:foo_token) { double(:foo_token) }
    let(:close_parens_token) { double(:close_parens_token) }

    let(:foo_expression) { double(:foo_expression) }
    let(:resulting_expression) { double(:resulting_expression) }

    context "when the tokens list is 1" do
      before do
        stack_item = expression_stack_item(foo_expression, 3)
        map_token_checker_response(
          foo_token_checker, from: constant_token, stack_item:, next_expected_token_type: :post_foo_token_checkers
        )

        map_evaluation_stack_reducer_response(from: [stack_item], to: double(:result, last_item: stack_item))
      end

      let(:tokens) { [constant_token] }
      let(:constant_token) { double(:constant_token) }

      it "returns a Constant Expression 1" do
        expect(build).to eq(foo_expression)
      end
    end

    context "when the tokens list is empty" do
      let(:tokens) { [] }

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::EmptyTokensListError)
      end
    end

    context "when the tokens list is +" do
      before do
        map_token_checker_response(
          frobulator_token_checker,
          from: operator_token,
          stack_item: command_stack_item(nil, 2), next_expected_token_type: :post_frobulator_token_checkers
        )
      end

      let(:tokens) { [operator_token] }
      let(:operator_token) { double(:operator_token) }

      it "raises an invalid syntax error" do
        expect { build }
          .to raise_error(SymDiffer::ExpressionTextLanguageCompiler::InvalidTokenTerminatedExpressionError)
      end
    end

    context "when the tokens list is x + x" do
      before do
        map_evaluation_stack_reducer_response(
          from: [expression_stack_item(foo_expression, 2),
                 command_stack_item(nil, 2),
                 expression_stack_item(foo_expression, 2)],
          to: double(:result, last_item: expression_stack_item(resulting_expression, 2))
        )
      end

      let(:tokens) { [foo_token, frobulator_token, foo_token] }

      it "returns a Sum Expression x + x" do
        expect(build).to eq(resulting_expression)
      end
    end

    context "when the tokens list is x x" do
      let(:tokens) { [foo_token, foo_token] }

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::ExpectedTokenTypeNotFoundError)
      end
    end

    context "when the tokens list is --1 (clarification)" do
      before do
        frobulator_stack_item = command_stack_item(nil, 2)

        2.times do
          map_token_checker_response(
            frobulator_token_checker, from: frobulator_token,
                                      stack_item: frobulator_stack_item,
                                      next_expected_token_type: :post_frobulator_token_checkers
          )
        end

        result_stack_item = expression_stack_item(resulting_expression, 2)

        map_evaluation_stack_reducer_response(
          from: [frobulator_stack_item, frobulator_stack_item, expression_stack_item(foo_expression, 2)],
          to: double(:result, last_item: result_stack_item)
        )
      end

      let(:tokens) { [frobulator_token, frobulator_token, foo_token] }

      it "returns a NegateExpression --1" do
        expect(build).to eq(resulting_expression)
      end
    end

    context "when the tokens list is x * + x (clarification)" do
      before do
        foo_stack_item = expression_stack_item(foo_expression, 2)
        frobulator_stack_item = command_stack_item(nil, 2)
        result_stack_item = expression_stack_item(resulting_expression, 2)

        map_evaluation_stack_reducer_response(
          from: [foo_stack_item, frobulator_stack_item, frobulator_stack_item, foo_stack_item],
          to: double(:result, last_item: result_stack_item)
        )
      end

      let(:tokens) do
        [foo_token, frobulator_token, frobulator_token, foo_token]
      end

      it "returns a MultiplicateExpression" do
        expect(build).to eq(resulting_expression)
      end
    end

    context "when the tokens list is sine(x)" do
      before do
        result_stack_item = expression_stack_item(resulting_expression, 2)

        map_evaluation_stack_reducer_response(
          from: [command_stack_item(nil, 2), expression_stack_item(foo_expression, 5)],
          to: double(:result, last_item: result_stack_item)
        )
      end

      let(:tokens) do
        [frobulator_token, open_parens_token, foo_token, close_parens_token]
      end

      it "returns a SineExpression" do
        expect(build).to eq(resulting_expression)
      end
    end

    context "when the tokens list is sine(sine(x))" do
      before do
        result_stack_item = expression_stack_item(resulting_expression, 2)

        map_evaluation_stack_reducer_response(
          from: [
            command_stack_item(nil, 2),
            command_stack_item(nil, 5),
            expression_stack_item(foo_expression, 8)
          ],
          to: double(:result, last_item: result_stack_item)
        )
      end

      let(:tokens) do
        [frobulator_token, open_parens_token, frobulator_token, open_parens_token,
         foo_token, close_parens_token, close_parens_token]
      end

      it "returns a SineExpression" do
        expect(build).to eq(resulting_expression)
      end
    end

    context "when the tokens list is sine)" do
      let(:tokens) { [frobulator_token, close_parens_token] }

      it "raises an invalid syntax error" do
        expect { build }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::ImbalancedExpressionError)
      end
    end

    define_method(:map_evaluation_stack_reducer_response) do |from:, to:, input_stack_contents: from, output: to|
      allow(command_and_expression_stack_reducer)
        .to receive(:reduce)
        .with(an_object_having_attributes(stack: input_stack_contents))
        .and_return(output)
    end

    define_method(:map_token_checker_response) do |token_checker, from:, stack_item:, next_expected_token_type:|
      input = from
      output = token_checker_response(true, stack_item, next_expected_token_type)

      allow(token_checker).to receive(:check).with(input).and_return(output)
    end

    define_method(:token_checker_response) do |handled, stack_item, next_expected_token_type|
      { handled:, stack_item:, next_expected_token_type: }
    end

    define_method(:expression_stack_item) do |value, precedence|
      stack_item(:expression, value, precedence)
    end

    define_method(:command_stack_item) do |value, precedence|
      stack_item(:pending_command, value, precedence)
    end

    define_method(:stack_item) do |item_type, value, precedence, new_precedence_change = nil|
      { item_type:, value:, precedence:, new_precedence_change: }
    end
  end
end
