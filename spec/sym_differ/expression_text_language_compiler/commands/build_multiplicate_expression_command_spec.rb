# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/commands/build_multiplicate_expression_command"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildMultiplicateExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new(expression_factory).execute(arguments) }

    before do
      allow(multiplicand).to receive(:same_as?).with(multiplicand).and_return(true)
      allow(multiplier).to receive(:same_as?).with(multiplier).and_return(true)
    end

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }
    let(:arguments) { [multiplicand, multiplier] }

    let(:multiplicand) { double(:multiplicand) }
    let(:multiplier) { double(:multiplier) }

    it { is_expected.to be_same_as(multiplicate_expression(multiplicand, multiplier)) }

    define_method(:multiplicate_expression) do |multiplicand, multiplier|
      expression_factory.create_multiplicate_expression(multiplicand, multiplier)
    end
  end
end
