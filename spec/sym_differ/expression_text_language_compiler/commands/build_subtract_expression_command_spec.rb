# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/commands/build_subtract_expression_command"
require "sym_differ/expressions/subtract_expression"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildSubtractExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new(expression_factory).execute(arguments) }

    let(:expression_factory) { build_expression_factory }

    context "when the arguments have two expressions" do
      let(:arguments) { [minuend, subtrahend] }

      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it { is_expected.to have_attributes(minuend:, subtrahend:) }
    end

    context "when the arguments have only one expression" do
      let(:arguments) { [negated_expression] }

      let(:negated_expression) { double(:negated_expression) }

      it { is_expected.to have_attributes(negated_expression:) }
    end

    define_method(:build_expression_factory) do
      expression_factory = double(:expression_factory)

      allow(expression_factory).to receive(:create_subtract_expression) do |minuend, subtrahend|
        double(:subtract_expression, minuend:, subtrahend:)
      end

      allow(expression_factory).to receive(:create_negate_expression) do |negated_expression|
        double(:negate_expression, negated_expression:)
      end

      expression_factory
    end
  end
end
