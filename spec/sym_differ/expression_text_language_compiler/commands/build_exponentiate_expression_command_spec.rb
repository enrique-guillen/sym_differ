# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/commands/build_exponentiate_expression_command"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildExponentiateExpressionCommand do
  describe "#execute" do
    subject(:execute) do
      described_class.new(expression_factory).execute(arguments)
    end

    let(:expression_factory) { sym_differ_expression_factory }
    let(:arguments) { [base, power] }

    let(:base) { expression_test_double(:base) }
    let(:power) { expression_test_double(:power) }

    it { is_expected.to be_same_as(exponentiate_expression(base, power)) }
  end
end
