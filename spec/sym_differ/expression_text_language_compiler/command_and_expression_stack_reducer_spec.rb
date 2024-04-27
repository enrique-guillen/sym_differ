# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/command_and_expression_stack_reducer"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::CommandAndExpressionStackReducer do
  describe "#reduce" do
    subject(:reduce) do
      described_class.new.reduce(command_and_expression_stack)
    end

    context "when the stack = [expression]" do
      let(:command_and_expression_stack) do
        [expression_stack_item(double(:expression))]
      end

      it { is_expected.to eq(command_and_expression_stack) }
    end

    context "when the stack = [earlier_expression, command, last_expression]" do
      before do
        allow(command)
          .to receive(:execute)
          .with([expression_a, expression_b])
          .and_return(command_execution_value)
      end

      let(:command_and_expression_stack) do
        [
          expression_stack_item(expression_a),
          command_stack_item(command),
          expression_stack_item(expression_b)
        ]
      end

      let(:expression_a) { double(:expression_a) }
      let(:command) { double(:command) }
      let(:expression_b) { double(:expression_b) }

      let(:command_execution_value) { double(:command_execution_value) }

      it { is_expected.to eq([expression_stack_item(command_execution_value)]) }
    end

    context "when the stack = [twice_earlier_expression, command1, earlier_expression, command2, last_expression]" do
      before do
        allow(command_1)
          .to receive(:execute)
          .with([expression_a, expression_b])
          .and_return(command_1_value)

        allow(command_2)
          .to receive(:execute)
          .with([command_1_value, expression_c])
          .and_return(command_2_value)
      end

      let(:command_and_expression_stack) do
        [
          expression_stack_item(expression_a),
          command_stack_item(command_1),
          expression_stack_item(expression_b),
          command_stack_item(command_2),
          expression_stack_item(expression_c)
        ]
      end

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

      it { is_expected.to eq([expression_stack_item(command_2_value)]) }
    end

    context "when the stack = [command1, command2, expression]" do
      before do
        allow(command_2)
          .to receive(:execute)
          .with([expression])
          .and_return(command_2_execution_value)

        allow(command_1)
          .to receive(:execute)
          .with([command_2_execution_value])
          .and_return(command_1_execution_value)
      end

      let(:command_and_expression_stack) do
        [
          command_stack_item(command_1),
          command_stack_item(command_2),
          expression_stack_item(expression)
        ]
      end

      let(:command_1) { double(:command_1) }
      let(:command_2) { double(:command_2) }
      let(:expression) { double(:expression) }

      let(:command_2_execution_value) do
        double(:command_2_execution_value)
      end

      let(:command_1_execution_value) do
        double(:command_1_execution_value)
      end

      it { is_expected.to eq([expression_stack_item(command_1_execution_value)]) }
    end

    context "when the stack = [exp, { command precedence 0 }, exp, { command precedence 1 }, exp]" do
      before do
        allow(higher_precedence_command)
          .to receive(:execute)
          .with([expression_b, expression_c])
          .and_return(higher_precedence_command_value)

        allow(lower_precedence_command)
          .to receive(:execute)
          .with([expression_a, higher_precedence_command_value])
          .and_return(lower_precedence_command_value)
      end

      let(:command_and_expression_stack) do
        [
          expression_stack_item(expression_a),
          command_stack_item(lower_precedence_command, 0),
          expression_stack_item(expression_b),
          command_stack_item(higher_precedence_command, 1),
          expression_stack_item(expression_c)
        ]
      end

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

      it { is_expected.to eq([expression_stack_item(lower_precedence_command_value)]) }
    end

    context "when the stack = [exp, higher_precedence_command, lower_precedence_command, exp]" do
      before do
        allow(higher_precedence_command)
          .to receive(:execute)
          .with([expression_a, lower_precedence_command_value])
          .and_return(higher_precedence_command_value)

        allow(lower_precedence_command)
          .to receive(:execute)
          .with([expression_b])
          .and_return(lower_precedence_command_value)
      end

      let(:command_and_expression_stack) do
        [
          expression_stack_item(expression_a),
          command_stack_item(higher_precedence_command, 1),
          command_stack_item(lower_precedence_command, 0),
          expression_stack_item(expression_b)
        ]
      end

      let(:expression_a) { double(:expression_a) }
      let(:higher_precedence_command) { double(:higher_precedence_command) }
      let(:lower_precedence_command) { double(:lower_precedence_command) }
      let(:expression_b) { double(:expression_b) }

      let(:higher_precedence_command_value) do
        double(:higher_precedence_command_value)
      end

      let(:lower_precedence_command_value) do
        double(:lower_precedence_command_value)
      end

      it { is_expected.to eq([expression_stack_item(higher_precedence_command_value)]) }
    end

    context "when the stack = [exp, higher_precedence_cmd, lower_precedence_cmd, lowest_precedence_cmd, exp]" do
      before do
        allow(higher_precedence_command)
          .to receive(:execute)
          .with([expression_a, lower_precedence_command_value])
          .and_return(higher_precedence_command_value)

        allow(lower_precedence_command)
          .to receive(:execute)
          .with([lowest_precedence_command_value])
          .and_return(lower_precedence_command_value)

        allow(lowest_precedence_command)
          .to receive(:execute)
          .with([expression_b])
          .and_return(lowest_precedence_command_value)
      end

      let(:command_and_expression_stack) do
        [
          expression_stack_item(expression_a),
          command_stack_item(higher_precedence_command, 3),
          command_stack_item(lower_precedence_command, 2),
          command_stack_item(lowest_precedence_command, 1),
          expression_stack_item(expression_b)
        ]
      end

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

      it { is_expected.to eq([expression_stack_item(higher_precedence_command_value)]) }
    end

    define_method(:command_stack_item) do |command, precedence = 0|
      build_stack_item(:pending_command, command, precedence)
    end

    define_method(:expression_stack_item) do |expression|
      build_stack_item(:expression, expression)
    end

    define_method(:build_stack_item) do |item_type, value, precedence = 0|
      { item_type:, value:, precedence: }
    end
  end
end
