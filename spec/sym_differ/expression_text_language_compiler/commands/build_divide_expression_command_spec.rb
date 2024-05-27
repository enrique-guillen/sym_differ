# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/commands/build_divide_expression_command"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildDivideExpressionCommand do
  describe "#execute" do
    subject(:execute) do
      described_class.new(expression_factory).execute(arguments)
    end

    let(:expression_factory) { sym_differ_expression_factory }
    let(:arguments) { [numerator, denominator] }

    let(:numerator) { expression_test_double(:numerator) }
    let(:denominator) { expression_test_double(:denominator) }

    it { is_expected.to be_same_as(divide_expression(numerator, denominator)) }
  end
end
