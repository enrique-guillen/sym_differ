# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/build_sum_expression_command"
require "sym_differ/sum_expression"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::BuildSumExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new(expression_factory).execute([expression_a, expression_b]) }

    let(:expression_factory) { build_expression_factory }

    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    it { is_expected.to have_attributes(expression_a:, expression_b:) }

    define_method(:build_expression_factory) do
      expression_factory = double(:expression_factory)

      allow(expression_factory).to receive(:create_sum_expression) do |expression_a, expression_b|
        double(:sum_expression, expression_a:, expression_b:)
      end

      expression_factory
    end
  end
end
