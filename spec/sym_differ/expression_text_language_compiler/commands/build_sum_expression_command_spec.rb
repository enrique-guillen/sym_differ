# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/commands/build_sum_expression_command"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildSumExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new(expression_factory).execute(arguments) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    context "when the arguments are expression_a, expression_b" do
      before do
        allow(expression_a).to receive(:same_as?).with(expression_a).and_return(true)
        allow(expression_b).to receive(:same_as?).with(expression_b).and_return(true)
      end

      let(:arguments) { [expression_a, expression_b] }
      let(:expression_a) { double(:expression_a) }
      let(:expression_b) { double(:expression_b) }

      it { is_expected.to be_same_as(sum_expression(expression_a, expression_b)) }
    end

    context "when the arguments are 1 summand" do
      before do
        allow(summand).to receive(:same_as?).with(summand).and_return(true)
      end

      let(:arguments) { [summand] }
      let(:summand) { double(:summand) }

      it { is_expected.to be_same_as(positive_expression(summand)) }
    end

    define_method(:sum_expression) do |expression_a, expression_b|
      expression_factory.create_sum_expression(expression_a, expression_b)
    end

    define_method(:positive_expression) do |summand|
      expression_factory.create_positive_expression(summand)
    end
  end
end
