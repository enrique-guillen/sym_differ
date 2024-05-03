# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/commands/build_sum_expression_command"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildSumExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new(expression_factory).execute(arguments) }

    let(:expression_factory) { build_expression_factory }

    context "when the arguments are expression_a, expression_b" do
      let(:arguments) { [expression_a, expression_b] }
      let(:expression_a) { double(:expression_a) }
      let(:expression_b) { double(:expression_b) }

      it { is_expected.to have_attributes(expression_a:, expression_b:) }
    end

    context "when the arguments are 1 summand" do
      let(:arguments) { [summand] }
      let(:summand) { double(:summand) }

      it { is_expected.to have_attributes(summand:) }
    end

    define_method(:build_expression_factory) do
      expression_factory = double(:expression_factory)

      allow(expression_factory).to receive(:create_sum_expression) do |expression_a, expression_b|
        double(:sum_expression, expression_a:, expression_b:)
      end

      allow(expression_factory).to receive(:create_positive_expression) do |summand|
        double(:positive_expression, summand:)
      end

      expression_factory
    end
  end
end
