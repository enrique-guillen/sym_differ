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
      before do
        allow(minuend).to receive(:same_as?).with(minuend).and_return(true)
        allow(subtrahend).to receive(:same_as?).with(subtrahend).and_return(true)
      end

      let(:arguments) { [minuend, subtrahend] }

      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it { is_expected.to be_same_as(subtract_expression(minuend, subtrahend)) }
    end

    context "when the arguments have only one expression" do
      before { allow(negated_expression).to receive(:same_as?).with(negated_expression).and_return(true) }

      let(:arguments) { [negated_expression] }

      let(:negated_expression) { double(:negated_expression) }

      it { is_expected.to be_same_as(negate_expression(negated_expression)) }
    end

    define_method(:subtract_expression) do |minuend, subtrahend|
      expression_factory.create_subtract_expression(minuend, subtrahend)
    end

    define_method(:negate_expression) do |negated_expression|
      expression_factory.create_negate_expression(negated_expression)
    end
  end
end
