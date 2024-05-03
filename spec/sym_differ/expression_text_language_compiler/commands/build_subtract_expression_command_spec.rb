# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/commands/build_subtract_expression_command"

require "sym_differ/expressions/subtract_expression"
require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildSubtractExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new(expression_factory).execute(arguments) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    context "when the arguments have two expressions" do
      let(:arguments) { [minuend, subtrahend] }

      let(:minuend) { expression_test_double(:minuend) }
      let(:subtrahend) { expression_test_double(:subtrahend) }

      it { is_expected.to be_same_as(subtract_expression(minuend, subtrahend)) }
    end

    context "when the arguments have only one expression" do
      let(:arguments) { [negated_expression] }

      let(:negated_expression) { expression_test_double(:negated_expression) }

      it { is_expected.to be_same_as(negate_expression(negated_expression)) }
    end
  end
end
