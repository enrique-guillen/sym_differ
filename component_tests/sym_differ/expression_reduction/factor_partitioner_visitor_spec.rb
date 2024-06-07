# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/factor_partitioner_visitor"

RSpec.describe SymDiffer::ExpressionReduction::FactorPartitionerVisitor do
  let(:visitor) { described_class.new }

  let(:expression_factory) { sym_differ_expression_factory }

  describe "#partition" do
    subject(:partition) do
      visitor.partition(expression)
    end

    before do
      allow(expression)
        .to receive(:accept)
        .with(visitor)
        .and_return(visit_result)
    end

    let(:expression) { double(:expression) }
    let(:visit_result) { double(:visit_result) }

    it { is_expected.to eq(visit_result) }
  end

  describe "#visit_constant_expression" do
    subject(:visit_constant_expression) do
      described_class.new.visit_constant_expression(expression)
    end

    let(:expression) { constant_expression(2) }

    it { is_expected.to match(factor_partition(2, nil)) }
  end

  describe "#visit_variable_expression" do
    subject(:visit_variable_expression) do
      described_class.new.visit_variable_expression(expression)
    end

    let(:expression) { variable_expression("x") }

    it { is_expected.to match(factor_partition(1, same_expression_as(variable_expression("x")))) }
  end

  define_method(:factor_partition) do |constant, subexpression|
    [constant, subexpression]
  end
end
