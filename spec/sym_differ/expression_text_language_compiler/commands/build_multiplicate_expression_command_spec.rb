# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/commands/build_multiplicate_expression_command"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildMultiplicateExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new(expression_factory).execute(arguments) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }
    let(:arguments) { [multiplicand, multiplier] }

    let(:multiplicand) { expression_test_double(:multiplicand) }
    let(:multiplier) { expression_test_double(:multiplier) }

    it { is_expected.to be_same_as(multiplicate_expression(multiplicand, multiplier)) }
  end
end
