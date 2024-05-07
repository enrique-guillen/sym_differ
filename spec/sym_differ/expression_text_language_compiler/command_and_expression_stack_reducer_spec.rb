# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/command_and_expression_stack_reducer"

require "sym_differ/expression_text_language_compiler/evaluation_stack"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::CommandAndExpressionStackReducer do
  describe "#reduce" do
    subject(:reduce) do
      described_class.new.reduce(evaluation_stack(command_and_expression_stack))
    end

    context "when the stack = [expression]" do
      let(:command_and_expression_stack) do
        [expression_stack_item(double(:expression))]
      end

      let(:precedence) { 3 }

      it { is_expected.to have_attributes(stack: command_and_expression_stack) }
    end

    context "when the stack = [earlier_expression, command, last_expression]" do
      before do
        map_command_response(command, from: [expression_a, expression_b], to: command_execution_value)
      end

      let(:command_and_expression_stack) do
        [
          expression_stack_item(expression_a),
          command_stack_item(command, 1, (0..2)),
          expression_stack_item(expression_b)
        ]
      end

      let(:precedence) { 1 }

      let(:expression_a) { double(:expression_a) }
      let(:command) { double(:command) }
      let(:expression_b) { double(:expression_b) }

      let(:command_execution_value) { double(:command_execution_value) }

      it { is_expected.to have_attributes(stack: [expression_stack_item(command_execution_value)]) }
    end

    context "when the stack = [twice_earlier_expression, command1, earlier_expression, command2, last_expression]" do
      before do
        map_command_response(command_1, from: [expression_a, expression_b], to: command_1_value)
        map_command_response(command_2, from: [command_1_value, expression_c], to: command_2_value)
      end

      let(:command_and_expression_stack) do
        [
          expression_stack_item(expression_a),
          command_stack_item(command_1, 0, (0..2)),
          expression_stack_item(expression_b),
          command_stack_item(command_2, 0, (0..2)),
          expression_stack_item(expression_c)
        ]
      end

      let(:precedence) { 0 }

      let(:expression_a) { double(:expression_a) }
      let(:command_1) { double(:command_1) }
      let(:expression_b) { double(:expression_b) }
      let(:command_2) { double(:command_2) }
      let(:expression_c) { double(:expression_c) }

      let(:command_1_value) do
        double(:command_1_value)
      end

      let(:command_2_value) do
        double(:command_2_value)
      end

      it { is_expected.to have_attributes(stack: [expression_stack_item(command_2_value)]) }
    end

    context "when the stack = [command1, command2, expression]" do
      before do
        map_command_response(command_2, from: [expression], to: command_2_execution_value)
        map_command_response(command_1, from: [command_2_execution_value], to: command_1_execution_value)
      end

      let(:command_and_expression_stack) do
        [
          command_stack_item(command_1, 0),
          command_stack_item(command_2, 1),
          expression_stack_item(expression)
        ]
      end

      let(:precedence) { 1 }

      let(:command_1) { double(:command_1) }
      let(:command_2) { double(:command_2) }
      let(:expression) { double(:expression) }

      let(:command_2_execution_value) do
        double(:command_2_execution_value)
      end

      let(:command_1_execution_value) do
        double(:command_1_execution_value)
      end

      it { is_expected.to have_attributes(stack: [expression_stack_item(command_1_execution_value)]) }
    end

    context "when the stack = [exp, { command precedence 0 }, exp, { command precedence 1 }, exp]" do
      before do
        map_command_response(higher_precedence_command,
                             from: [expression_b, expression_c], to: higher_precedence_command_value)

        map_command_response(lower_precedence_command,
                             from: [expression_a, higher_precedence_command_value], to: lower_precedence_command_value)
      end

      let(:command_and_expression_stack) do
        [
          expression_stack_item(expression_a),
          command_stack_item(lower_precedence_command, 0, (0..2)),
          expression_stack_item(expression_b),
          command_stack_item(higher_precedence_command, 1, (0..2)),
          expression_stack_item(expression_c)
        ]
      end

      let(:precedence) { 1 }

      let(:expression_a) { double(:expression_a) }
      let(:higher_precedence_command) { double(:higher_precedence_command) }
      let(:expression_b) { double(:expression_b) }
      let(:lower_precedence_command) { double(:lower_precedence_command) }
      let(:expression_c) { double(:expression_c) }

      let(:higher_precedence_command_value) do
        double(:higher_precedence_command_value)
      end

      let(:lower_precedence_command_value) do
        double(:lower_precedence_command_value)
      end

      it { is_expected.to have_attributes(stack: [expression_stack_item(lower_precedence_command_value)]) }
    end

    context "when the stack = [exp, lower_precedence_command, higher_precedence_command, exp]" do
      before do
        map_command_response(lower_precedence_command,
                             from: [expression_a, higher_precedence_command_value], to: lower_precedence_command_value)

        map_command_response(higher_precedence_command, from: [expression_b], to: higher_precedence_command_value)
      end

      let(:command_and_expression_stack) do
        [
          expression_stack_item(expression_a),
          command_stack_item(lower_precedence_command, 0, (0..2)),
          command_stack_item(higher_precedence_command, 1, (0..2)),
          expression_stack_item(expression_b)
        ]
      end

      let(:precedence) { 1 }

      let(:expression_a) { double(:expression_a) }
      let(:lower_precedence_command) { double(:lower_precedence_command) }
      let(:higher_precedence_command) { double(:higher_precedence_command) }
      let(:expression_b) { double(:expression_b) }

      let(:lower_precedence_command_value) do
        double(:lower_precedence_command_value)
      end

      let(:higher_precedence_command_value) do
        double(:higher_precedence_command_value)
      end

      it { is_expected.to have_attributes(stack: [expression_stack_item(lower_precedence_command_value)]) }
    end

    context "when the stack = [exp, lowest_precedence_cmd, lower_precedence_cmd, higher_precedence_cmd, exp]" do
      before do
        map_command_response(lowest_precedence_command,
                             from: [expression_a, lower_precedence_command_value], to: lowest_precedence_command_value)

        map_command_response(lower_precedence_command,
                             from: [higher_precedence_command_value], to: lower_precedence_command_value)

        map_command_response(higher_precedence_command, from: [expression_b], to: higher_precedence_command_value)
      end

      let(:command_and_expression_stack) do
        [
          expression_stack_item(expression_a),
          command_stack_item(lowest_precedence_command, 1, (0..2)),
          command_stack_item(lower_precedence_command, 2, (0..2)),
          command_stack_item(higher_precedence_command, 3, (0..2)),
          expression_stack_item(expression_b)
        ]
      end

      let(:precedence) { 3 }

      let(:expression_a) { double(:expression_a) }
      let(:higher_precedence_command) { double(:higher_precedence_command) }
      let(:lower_precedence_command) { double(:lower_precedence_command) }
      let(:lowest_precedence_command) { double(:lowest_precedence_command) }
      let(:expression_b) { double(:expression_b) }

      let(:higher_precedence_command_value) do
        double(:higher_precedence_command_value)
      end

      let(:lower_precedence_command_value) do
        double(:lower_precedence_command_value)
      end

      let(:lowest_precedence_command_value) do
        double(:lowest_precedence_command_value)
      end

      it { is_expected.to have_attributes(stack: [expression_stack_item(lowest_precedence_command_value)]) }
    end

    context "when the stack = [zero_arity_command] (clarification)" do
      before do
        map_command_response(zero_arity_command, from: [], to: zero_arity_command_value)
      end

      let(:command_and_expression_stack) do
        [command_stack_item(zero_arity_command, 1)]
      end

      let(:precedence) { 1 }

      let(:zero_arity_command) { double(:zero_arity_command) }

      let(:zero_arity_command_value) { double(:zero_arity_command_value) }

      it { is_expected.to have_attributes(stack: [expression_stack_item(zero_arity_command_value)]) }
    end

    context(<<~DOCSTRING) do
      when the stack = [
        expression(1, pre0),
        opcommand(+, pre1),
        idcommand(sin(, pre1)),
        idcommand(x), pre2)
      ] (clarification)
    DOCSTRING
      before do
        map_command_response(x_command, from: [], to: x_command_value)
        map_command_response(sine_command, from: [x_command_value], to: sine_command_value)
        map_command_response(sum_command, from: [constant_expression, sine_command_value], to: sum_command_value)
      end

      let(:command_and_expression_stack) do
        [
          expression_stack_item(constant_expression, 1),
          command_stack_item(sum_command, 0, (0..2)),
          command_stack_item(sine_command, 1, (0..2)),
          command_stack_item(x_command, 2, (0..2))
        ]
      end

      let(:precedence) { 2 }

      let(:constant_expression) { double(:constant_expression) }
      let(:sum_command) { double(:sum_command) }
      let(:sine_command) { double(:sine_command) }
      let(:x_command) { double(:x_command) }

      let(:sine_command_value) { double(:sine_command_value) }
      let(:x_command_value) { double(:x_command_value) }
      let(:sum_command_value) { double(:sum_command_value) }

      it { is_expected.to have_attributes(stack: [expression_stack_item(sum_command_value)]) }
    end

    context "when the stack = [x_command, sine_command] same precedence (clarification)" do
      before do
        map_command_response(x_command, from: [sine_command_value], to: x_command_value)
        map_command_response(sine_command, from: [], to: sine_command_value)
      end

      let(:command_and_expression_stack) do
        [command_stack_item(x_command, 1, (0..1)), command_stack_item(sine_command, 1, (0..1))]
      end

      let(:precedence) { 1 }

      let(:x_command) { double(:x_command) }
      let(:sine_command) { double(:sine_command) }

      let(:x_command_value) { double(:x_command_value) }
      let(:sine_command_value) { double(:sine_command_value) }

      it { is_expected.to have_attributes(stack: [expression_stack_item(x_command_value)]) }
    end

    context "when the stack = [subtract_command, subtract_command, expression]" do
      before do
        map_command_response(subtract_command_1, from: [subtract_command_2_value], to: subtract_command_1_value)
        map_command_response(subtract_command_2, from: [x_expression], to: subtract_command_2_value)
      end

      let(:command_and_expression_stack) do
        [
          command_stack_item(subtract_command_1, 1, (0..2)),
          command_stack_item(subtract_command_2, 1, (0..2)),
          expression_stack_item(x_expression)
        ]
      end

      let(:precedence) { 1 }

      let(:subtract_command_1) { double(:subtract_command_1) }
      let(:subtract_command_2) { double(:subtract_command_2) }
      let(:x_expression) { double(:x_expression) }

      let(:subtract_command_1_value) { double(:subtract_command_1_value) }
      let(:subtract_command_2_value) { double(:subtract_command_2_value) }
      let(:x_expression_value) { double(:x_expression_value) }

      it { is_expected.to have_attributes(stack: [expression_stack_item(subtract_command_1_value)]) }
    end

    context "when the stack = [command], higher precedence" do
      before do
        map_command_response(command, from: [], to: command_value)
      end

      let(:command_and_expression_stack) do
        [command_stack_item(command, 1)]
      end

      let(:command) { double(:command) }
      let(:command_value) { double(:command_value) }

      let(:precedence) { 5 }

      it { is_expected.to have_attributes(stack: [expression_stack_item(command_value)]) }
    end

    context "when the stack = [expression, command, lower_precedence_unary_command, expression], higher precedence" do
      before do
        map_command_response(lower_precedence_unary_command,
                             from: [expression_b], to: lower_precedence_unary_command_value)

        map_command_response(high_precedence_binary_command,
                             from: [expression_a, lower_precedence_unary_command_value],
                             to: high_precedence_binary_command_value)
      end

      let(:command_and_expression_stack) do
        [
          expression_stack_item(expression_a),
          command_stack_item(high_precedence_binary_command, 3, (2..2)),
          command_stack_item(lower_precedence_unary_command, 2, (2..2)),
          expression_stack_item(expression_b)
        ]
      end

      let(:expression_a) { double(:expression_a) }
      let(:high_precedence_binary_command) { double(:high_precedence_binary_command) }
      let(:lower_precedence_unary_command) { double(:lower_precedence_unary_command) }
      let(:expression_b) { double(:expression_b) }

      let(:expression_a_value) { double(:expression_a_value) }
      let(:high_precedence_binary_command_value) { double(:high_precedence_binary_command_value) }
      let(:lower_precedence_unary_command_value) { double(:lower_precedence_unary_command_value) }
      let(:expression_b_value) { double(:expression_b_value) }

      let(:precedence) { 3 }

      it { is_expected.to have_attributes(stack: [expression_stack_item(high_precedence_binary_command_value)]) }
    end

    define_method(:evaluation_stack) do |stack|
      SymDiffer::ExpressionTextLanguageCompiler::EvaluationStack.new(stack)
    end

    define_method(:map_command_response) do |command, from:, to:, input: from, output: to|
      allow(command)
        .to receive(:execute)
        .with(input)
        .and_return(output)
    end

    define_method(:command_stack_item) do |command, precedence, argument_amount_range = (0..0)|
      build_stack_item(:pending_command, command, precedence, argument_amount_range.min, argument_amount_range.max)
    end

    define_method(:expression_stack_item) do |expression, precedence = 0|
      build_stack_item(:expression, expression, precedence)
    end

    define_method(:build_stack_item) do |
      item_type, value, precedence = 0, min_argument_amount = nil, max_argument_amount = nil
    |
      { item_type:, value:, precedence:, max_argument_amount:, min_argument_amount: }.compact
    end
  end
end
