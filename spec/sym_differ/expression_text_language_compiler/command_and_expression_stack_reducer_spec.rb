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
          .and_return(value_of_applying_command_to_expressions)
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

      let(:value_of_applying_command_to_expressions) do
        double(:value_of_applying_command_to_expressions)
      end

      it { is_expected.to eq([expression_stack_item(value_of_applying_command_to_expressions)]) }
    end

    context "when the stack = [twice_earlier_expression, command1, earlier_expression, command2, last_expression]" do
      before do
        allow(command_2)
          .to receive(:execute)
          .with([expression_b, expression_c])
          .and_return(value_of_applying_command_2_to_expressions)

        allow(command_1)
          .to receive(:execute)
          .with([expression_a, value_of_applying_command_2_to_expressions])
          .and_return(value_of_applying_command_1_to_expressions)
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

      let(:value_of_applying_command_1_to_expressions) do
        double(:value_of_applying_command_1_to_expressions)
      end

      let(:value_of_applying_command_2_to_expressions) do
        double(:value_of_applying_command_2_to_expressions)
      end

      it { is_expected.to eq([expression_stack_item(value_of_applying_command_1_to_expressions)]) }
    end

    context "when the stack = [command1, command2, expression]" do
      before do
        allow(command_2)
          .to receive(:execute)
          .with([expression])
          .and_return(value_of_applying_command_2_to_expression)

        allow(command_1)
          .to receive(:execute)
          .with([value_of_applying_command_2_to_expression])
          .and_return(value_of_applying_command_1_to_expression)
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

      let(:value_of_applying_command_2_to_expression) do
        double(:value_of_applying_command_2_to_expression)
      end

      let(:value_of_applying_command_1_to_expression) do
        double(:value_of_applying_command_1_to_expression)
      end

      it { is_expected.to eq([expression_stack_item(value_of_applying_command_1_to_expression)]) }
    end

    define_method(:command_stack_item) do |command|
      build_stack_item(:pending_command, command)
    end

    define_method(:expression_stack_item) do |expression|
      build_stack_item(:expression, expression)
    end

    define_method(:build_stack_item) do |item_type, value|
      { item_type:, value: }
    end
  end
end
