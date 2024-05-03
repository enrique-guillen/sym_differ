# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/commands/build_sum_expression_command"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildSumExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new(expression_factory).execute(arguments) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    context "when the arguments are expression_a, expression_b" do
      let(:arguments) { [expression_a, expression_b] }
      let(:expression_a) { expression_test_double(:expression_a) }
      let(:expression_b) { expression_test_double(:expression_b) }

      it { is_expected.to be_same_as(sum_expression(expression_a, expression_b)) }
    end

    context "when the arguments are 1 summand" do
      let(:arguments) { [summand] }
      let(:summand) { expression_test_double(:summand) }

      it { is_expected.to be_same_as(positive_expression(summand)) }
    end
  end
end
