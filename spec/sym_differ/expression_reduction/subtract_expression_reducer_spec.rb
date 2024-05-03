# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/subtract_expression_reducer"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReduction::SubtractExpressionReducer do
  describe "#reduce" do
    subject(:reduce) do
      described_class.new(expression_factory, reducer).reduce(expression)
    end

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }
    let(:reducer) { double(:reducer) }

    context "when the expression is 0-0" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(constant_expression(0)))
          .and_return(reduced_expression: constant_expression(0),
                      sum_partition: [0, nil],
                      factor_partition: [0, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { constant_expression(0) }
      let(:subtrahend) { constant_expression(0) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(constant_expression(0)),
            sum_partition(0, nil),
            factor_partition(0, nil)
          )
        )
      end
    end

    context "when the expression is 1-0" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(constant_expression(1)))
          .and_return(reduced_expression: constant_expression(1), sum_partition: [1, nil], factor_partition: [1, nil])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(subtrahend)
          .and_return(reduced_expression: constant_expression(0), sum_partition: [0, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { constant_expression(1) }
      let(:subtrahend) { constant_expression(0) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(constant_expression(1)),
            sum_partition(1, nil),
            factor_partition(1, nil)
          )
        )
      end
    end

    context "when the expression is x-0" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(variable_expression("x")))
          .and_return(reduced_expression: variable_expression("x"),
                      sum_partition: [0, variable_expression("x")],
                      factor_partition: [1, variable_expression("x")])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(constant_expression(0)))
          .and_return(reduced_expression: constant_expression(0), sum_partition: [0, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { variable_expression("x") }
      let(:subtrahend) { constant_expression(0) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(variable_expression("x")),
            sum_partition(0, same_expression_as(variable_expression("x"))),
            factor_partition(1, same_expression_as(variable_expression("x")))
          )
        )
      end
    end

    context "when the expression is 0-1" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(minuend)
          .and_return(reduced_expression: constant_expression(0), sum_partition: [0, nil])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(subtrahend)
          .and_return(reduced_expression: constant_expression(1), sum_partition: [1, nil])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(negate_expression(constant_expression(1))))
          .and_return(factor_partition: [-1, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { constant_expression(0) }
      let(:subtrahend) { constant_expression(1) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(negated_expression: an_object_having_attributes(value: 1)),
          sum_partition: [-1, nil],
          factor_partition: [-1, nil]
        )
      end
    end

    context "when the expression is 0-x" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(minuend)
          .and_return(reduced_expression: constant_expression(0), sum_partition: [0, nil])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(subtrahend)
          .and_return(reduced_expression: variable_expression("x"), sum_partition: [0, variable_expression("x")])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(negate_expression(variable_expression("x"))))
          .and_return(factor_partition: [-1, variable_expression("x")])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { constant_expression(0) }
      let(:subtrahend) { variable_expression("x") }

      it "returns the reductions of the subtraction expression" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(negated_expression: an_object_having_attributes(name: "x")),
          sum_partition: [0, an_object_having_attributes(negated_expression: an_object_having_attributes(name: "x"))]
        )
      end
    end

    context "when the expression is (x+x)-1" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(minuend)
          .and_return(reduced_expression: sum_expression(variable_expression("x"), variable_expression("x")),
                      sum_partition: [0, sum_expression(variable_expression("x"), variable_expression("x"))])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(subtrahend)
          .and_return(reduced_expression: constant_expression(1), sum_partition: [1, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { sum_expression(variable_expression("x"), variable_expression("x")) }
      let(:subtrahend) { constant_expression(1) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(
            minuend: an_object_having_attributes(expression_a: an_object_having_attributes(name: "x"),
                                                 expression_b: an_object_having_attributes(name: "x")),
            subtrahend: an_object_having_attributes(value: 1)
          ),
          sum_partition: [
            -1,
            an_object_having_attributes(expression_a: an_object_having_attributes(name: "x"),
                                        expression_b: an_object_having_attributes(name: "x"))
          ]
        )
      end
    end

    context "when the expression is x + 1 - (1-x)" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(minuend)
          .and_return(reduced_expression: sum_expression(variable_expression("x"), constant_expression(1)),
                      sum_partition: [1, variable_expression("x")])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(subtrahend)
          .and_return(reduced_expression: subtract_expression(constant_expression(1), variable_expression("x")),
                      sum_partition: [1, negate_expression(variable_expression("x"))])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(sum_expression(variable_expression("x"), variable_expression("x"))))
          .and_return(factor_partition: [1, sum_expression(variable_expression("x"), variable_expression("x"))])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { sum_expression(variable_expression("x"), constant_expression(1)) }
      let(:subtrahend) { subtract_expression(constant_expression(1), variable_expression("x")) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(expression_a: an_object_having_attributes(name: "x"),
                                                          expression_b: an_object_having_attributes(name: "x")),
          sum_partition: [
            0, an_object_having_attributes(expression_a: an_object_having_attributes(name: "x"),
                                           expression_b: an_object_having_attributes(name: "x"))
          ]
        )
      end
    end

    context "when the expression is 1+0-(0-1)" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(minuend)
          .and_return(reduced_expression: constant_expression(1),
                      sum_partition: [1, nil])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(subtrahend)
          .and_return(reduced_expression: negate_expression(constant_expression(1)),
                      sum_partition: [-1, nil])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(constant_expression(2)))
          .and_return(factor_partition: [2, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { sum_expression(constant_expression(1), constant_expression(0)) }
      let(:subtrahend) { subtract_expression(constant_expression(0), constant_expression(1)) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(value: 2),
          sum_partition: [2, nil]
        )
      end
    end

    context "when the expression is 1- x" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(minuend)
          .and_return(reduced_expression: constant_expression(1),
                      sum_partition: [1, nil])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(subtrahend)
          .and_return(reduced_expression: variable_expression("x"),
                      sum_partition: [0, variable_expression("x")])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(sum_expression(negate_expression(variable_expression("x")), constant_expression(1))))
          .and_return(factor_partition: [3, nil])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { constant_expression(1) }
      let(:subtrahend) { variable_expression("x") }

      it "returns the reductions of the subtraction expression" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(
            expression_a: an_object_having_attributes(negated_expression: an_object_having_attributes(name: "x")),
            expression_b: an_object_having_attributes(value: 1)
          ),
          sum_partition: [1, an_object_having_attributes(negated_expression: an_object_having_attributes(name: "x"))]
        )
      end
    end

    context "when the expression is 0 - (0 -x)" do
      before do
        allow(reducer)
          .to receive(:reduction_analysis)
          .with(minuend)
          .and_return(reduced_expression: constant_expression(0), sum_partition: [0, nil])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(subtrahend)
          .and_return(reduced_expression: negate_expression(variable_expression("x")),
                      sum_partition: [0, negate_expression(variable_expression("x"))])

        allow(reducer)
          .to receive(:reduction_analysis)
          .with(same_expression_as(variable_expression("x")))
          .and_return(factor_partition: [1, variable_expression("x")])
      end

      let(:expression) { subtract_expression(minuend, subtrahend) }
      let(:minuend) { constant_expression(0) }
      let(:subtrahend) { subtract_expression(constant_expression(0), variable_expression("x")) }

      it "returns the reductions of the subtraction expression" do
        expect(reduce).to include(
          reduced_expression: an_object_having_attributes(name: "x"),
          sum_partition: [0, an_object_having_attributes(name: "x")]
        )
      end
    end

    define_method(:reduction_results) do |reduced_expression, sum_partition, factor_partition|
      { reduced_expression:, sum_partition:, factor_partition: }
    end

    define_method(:sum_partition) do |constant, subexpression|
      [constant, subexpression]
    end

    define_method(:factor_partition) do |constant, subexpression|
      [constant, subexpression]
    end
  end
end
