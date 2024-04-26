# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/build_multiplicate_expression_command"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::BuildMultiplicateExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new(expression_factory).execute(arguments) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }
    let(:arguments) { [multiplicand, multiplier] }

    let(:multiplicand) { double(:multiplicand) }
    let(:multiplier) { double(:multiplier) }

    it { is_expected.to have_attributes(multiplicand:, multiplier:) }
  end
end
