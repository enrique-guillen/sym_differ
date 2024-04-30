# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/sum_expression_reducer"
require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReduction::SumExpressionReducer do
  describe "#reduce" do
    subject(:reduce) do
      described_class
        .new(expression_factory, reducer)
        .reduce(expression)
    end

    before do
      allow(reducer)
        .to receive(:reduction_analysis)
        .with(expression_a)
        .and_return(reduced_expression: reduced_expression_a, sum_partition: sum_partition_a)

      allow(reducer)
        .to receive(:reduction_analysis)
        .with(expression_b)
        .and_return(reduced_expression: reduced_expression_a, sum_partition: sum_partition_b)
    end

    let(:expression) { sum_expression(expression_a, expression_b) }

    let(:reducer) { double(:reducer) }
    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    let(:reduced_expression_a) { double(:reduced_expression_a) }
    let(:reduced_expression_b) { double(:reduced_expression_b) }

    context "when the expression is 1 + 1" do
      let(:sum_partition_a) { [1, nil] }
      let(:sum_partition_b) { [1, nil] }

      it "returns the reduction results 2, [2, nil]" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(value: 2),
          sum_partition: [2, nil],
          factor_partition: [1, an_object_having_attributes(value: 2)]
        )
      end
    end

    context "when the expression is (1+1)+x" do
      let(:sum_partition_a) { [2, nil] }
      let(:sum_partition_b) { [0, variable_expression("x")] }

      it "returns the reduction results x + 2, [2, x]" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(
            expression_a: an_object_having_attributes(name: "x"),
            expression_b: an_object_having_attributes(value: 2)
          ),
          sum_partition: [2, an_object_having_attributes(name: "x")]
        )
      end
    end

    context "when the expression is 1+(x+1)" do
      let(:sum_partition_a) { [0, variable_expression("x")] }
      let(:sum_partition_b) { [2, nil] }

      it "returns the reduction results x + 2, [2, x]" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(
            expression_a: an_object_having_attributes(name: "x"),
            expression_b: an_object_having_attributes(value: 2)
          ),
          sum_partition: [2, an_object_having_attributes(name: "x")]
        )
      end
    end

    context "when the expression is (x + 1) + (x + 1)" do
      let(:sum_partition_a) { [1, variable_expression("x")] }
      let(:sum_partition_b) { [1, variable_expression("x")] }

      it "returns the reduction results x + 2, [2, x]" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(
            expression_a: an_object_having_attributes(expression_a: an_object_having_attributes(name: "x"),
                                                      expression_b: an_object_having_attributes(name: "x")),
            expression_b: an_object_having_attributes(value: 2)
          ),
          sum_partition: [
            2, an_object_having_attributes(expression_a: an_object_having_attributes(name: "x"),
                                           expression_b: an_object_having_attributes(name: "x"))
          ]
        )
      end
    end

    context "when the expression is x+0" do
      let(:sum_partition_a) { [0, variable_expression("x")] }
      let(:sum_partition_b) { [0, nil] }

      it "returns the reduction results x, [0, x]" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(name: "x"),
          sum_partition: [0, an_object_having_attributes(name: "x")]
        )
      end
    end

    context "when the expression is 1+1" do
      let(:sum_partition_a) { [0, nil] }
      let(:sum_partition_b) { [0, nil] }

      it "returns the reduction results x, [0, x]" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(value: 0),
          sum_partition: [0, nil]
        )
      end
    end

    define_method(:variable_expression) do |name|
      expression_factory.create_variable_expression(name)
    end

    define_method(:sum_expression) do |expression_a, expression_b|
      expression_factory.create_sum_expression(expression_a, expression_b)
    end
  end
end
