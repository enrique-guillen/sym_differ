# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/multiplicate_expression_reducer"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReduction::MultiplicateExpressionReducer do
  describe "#reduce" do
    subject(:reduce) { described_class.new(expression_factory, reducer).reduce(expression) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }
    let(:reducer) { double(:reducer) }

    context "when the expression is x*x" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(multiplicand)
          .and_return(
            reduction_results(variable_expression("x"),
                              sum_partition(0, variable_expression("x")))
          )

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(multiplier)
          .and_return(
            reduction_results(variable_expression("x"),
                              sum_partition(0, variable_expression("x")))
          )
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results x * x, [0, x * x]" do
        expect(reduce).to include(
          reduction_results(
            an_object_having_attributes(multiplicand: an_object_having_attributes(name: "x"),
                                        multiplier: an_object_having_attributes(name: "x")),
            sum_partition(
              0,
              an_object_having_attributes(multiplicand: an_object_having_attributes(name: "x"),
                                          multiplier: an_object_having_attributes(name: "x"))
            )
          )
        )
      end
    end

    context "when the expression is x * 1" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(multiplicand)
          .and_return(
            reduction_results(variable_expression("x"),
                              sum_partition(0, variable_expression("x")))
          )

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(multiplier)
          .and_return(
            reduction_results(constant_expression(1),
                              sum_partition(1, nil))
          )
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results x, [0, x]" do
        expect(reduce).to include(
          reduction_results(
            an_object_having_attributes(name: "x"),
            sum_partition(0, an_object_having_attributes(name: "x"))
          )
        )
      end
    end

    context "when the expression is 1 * x" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(multiplicand)
          .and_return(
            reduction_results(constant_expression(1),
                              sum_partition(1, nil))
          )

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(multiplier)
          .and_return(
            reduction_results(variable_expression("x"),
                              sum_partition(0, variable_expression("x")))
          )
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results x, [0, x]" do
        expect(reduce).to include(
          reduction_results(
            an_object_having_attributes(name: "x"),
            sum_partition(0, an_object_having_attributes(name: "x"))
          )
        )
      end
    end

    context "when the expression is x * 0" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(multiplicand)
          .and_return(
            reduction_results(variable_expression("x"),
                              sum_partition(0, variable_expression("x")))
          )

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(multiplier)
          .and_return(
            reduction_results(constant_expression(0),
                              sum_partition(0, nil))
          )
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results 0, [0, 0]" do
        expect(reduce).to include(
          reduction_results(
            an_object_having_attributes(value: 0),
            sum_partition(0, nil)
          )
        )
      end
    end

    context "when the expression is 0 * x" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(multiplicand)
          .and_return(
            reduction_results(constant_expression(0),
                              sum_partition(0, nil))
          )

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(multiplier)
          .and_return(
            reduction_results(variable_expression("x"),
                              sum_partition(0, variable_expression("x")))
          )
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results 0, [0, 0]" do
        expect(reduce).to include(
          reduction_results(
            an_object_having_attributes(value: 0),
            sum_partition(0, nil)
          )
        )
      end
    end

    context "when the expression is 2 * 3" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(multiplicand)
          .and_return(
            reduction_results(constant_expression(2),
                              sum_partition(2, nil))
          )

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(multiplier)
          .and_return(
            reduction_results(constant_expression(3),
                              sum_partition(3, nil))
          )
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results 6, [6, nil]" do
        expect(reduce).to include(
          reduction_results(
            an_object_having_attributes(value: 6),
            sum_partition(6, nil)
          )
        )
      end
    end

    define_method(:multiplicate_expression) do |expression_a, expression_b|
      expression_factory.create_multiplicate_expression(expression_a, expression_b)
    end

    define_method(:constant_expression) do |value|
      expression_factory.create_constant_expression(value)
    end

    define_method(:variable_expression) do |name|
      expression_factory.create_variable_expression(name)
    end

    define_method(:reduction_results) do |reduced_expression, sum_partition|
      { reduced_expression:, sum_partition: }
    end

    define_method(:sum_partition) do |constant, subexpression|
      [constant, subexpression]
    end
  end
end
