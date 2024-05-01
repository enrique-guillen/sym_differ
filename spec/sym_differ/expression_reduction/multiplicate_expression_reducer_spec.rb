# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/multiplicate_expression_reducer"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReduction::MultiplicateExpressionReducer do
  describe "#reduce" do
    subject(:reduce) { described_class.new(expression_factory, reducer).reduce(expression) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }
    let(:reducer) { double(:reducer) }

    before do
      map_reduction_analysis(
        from: same_expression_as(constant_expression(0)),
        to: reduction_results(constant_expression(0), sum_partition(0, nil), factor_partition(0, nil))
      )

      map_reduction_analysis(
        from: same_expression_as(constant_expression(4)),
        to: reduction_results(constant_expression(4), sum_partition(4, nil), factor_partition(4, nil))
      )

      map_reduction_analysis(
        from: same_expression_as(variable_expression("x")),
        to: reduction_results(variable_expression("x"),
                              sum_partition(0, variable_expression("x")),
                              factor_partition(1, variable_expression("x")))
      )
    end

    context "when the expression is x*x" do
      before do
        map_reduction_analysis(
          from: multiplicand,
          to: reduction_results(variable_expression("x"),
                                sum_partition(0, variable_expression("x")),
                                factor_partition(1, variable_expression("x")))
        )

        map_reduction_analysis(
          from: multiplier,
          to: reduction_results(variable_expression("x"),
                                sum_partition(0, variable_expression("x")),
                                factor_partition(1, variable_expression("x")))
        )
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results x * x, [0, x * x]" do
        expected_reduced_expression = multiplicate_expression(variable_expression("x"), variable_expression("x"))

        expected_sum_partition_subexpression =
          multiplicate_expression(variable_expression("x"), variable_expression("x"))

        expected_factor_partition_subexpression =
          multiplicate_expression(variable_expression("x"), variable_expression("x"))

        expect(reduce).to include(
          reduction_results(
            same_expression_as(expected_reduced_expression),
            sum_partition(0, same_expression_as(expected_sum_partition_subexpression)),
            factor_partition(1, same_expression_as(expected_factor_partition_subexpression))
          )
        )
      end
    end

    context "when the expression is 2*2" do
      before do
        map_reduction_analysis(
          from: multiplicand,
          to: reduction_results(constant_expression(2), sum_partition(2, nil), factor_partition(2, nil))
        )

        map_reduction_analysis(
          from: multiplier,
          to: reduction_results(constant_expression(2), sum_partition(2, nil), factor_partition(2, nil))
        )
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results 4, [4, nil], [4, nil]" do
        expect(reduce).to include(
          reduction_results(
            same_expression_as(constant_expression(4)),
            sum_partition(4, nil),
            factor_partition(4, nil)
          )
        )
      end
    end

    context "when the expression is x * 1" do
      before do
        map_reduction_analysis(
          from: multiplicand,
          to: reduction_results(variable_expression("x"),
                                sum_partition(0, variable_expression("x")),
                                factor_partition(1, variable_expression("x")))
        )

        map_reduction_analysis(
          from: multiplier,
          to: reduction_results(constant_expression(1),
                                sum_partition(1, nil),
                                factor_partition(1, nil))
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
            same_expression_as(variable_expression("x")),
            sum_partition(0, same_expression_as(variable_expression("x"))),
            factor_partition(1, same_expression_as(variable_expression("x")))
          )
        )
      end
    end

    context "when the expression is 1 * x" do
      before do
        map_reduction_analysis(
          from: multiplicand,
          to: reduction_results(constant_expression(1),
                                sum_partition(1, nil),
                                factor_partition(1, nil))
        )

        map_reduction_analysis(
          from: multiplier,
          to: reduction_results(variable_expression("x"),
                                sum_partition(0, variable_expression("x")),
                                factor_partition(1, variable_expression("x")))
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
            same_expression_as(variable_expression("x")),
            sum_partition(0, same_expression_as(variable_expression("x"))),
            factor_partition(1, same_expression_as(variable_expression("x")))
          )
        )
      end
    end

    context "when the expression is x * 0" do
      before do
        map_reduction_analysis(
          from: multiplicand,
          to: reduction_results(variable_expression("x"),
                                sum_partition(0, variable_expression("x")),
                                factor_partition(1, variable_expression("x")))
        )

        map_reduction_analysis(
          from: multiplier,
          to: reduction_results(constant_expression(0), sum_partition(0, nil), factor_partition(0, nil))
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
            same_expression_as(constant_expression(0)),
            sum_partition(0, nil),
            factor_partition(0, nil)
          )
        )
      end
    end

    context "when the expression is 3x * 3" do
      before do
        map_reduction_analysis(
          from: multiplicand,
          to: reduction_results(multiplicate_expression(constant_expression(3), variable_expression("x")),
                                sum_partition(0, variable_expression("x")),
                                factor_partition(3, variable_expression("x")))
        )

        map_reduction_analysis(
          from: multiplier,
          to: reduction_results(constant_expression(3),
                                sum_partition(3, nil),
                                factor_partition(3, nil))
        )
      end

      let(:expression) do
        multiplicate_expression(multiplicand, multiplier)
      end

      let(:multiplicand) { double(:multiplicand) }
      let(:multiplier) { double(:multiplier) }

      it "returns the reduction results 9x, [0, 9x], [9, x]" do
        expected_reduced_expression = multiplicate_expression(constant_expression(9), variable_expression("x"))
        expected_sum_partition_subexpression = multiplicate_expression(constant_expression(9), variable_expression("x"))
        expected_factor_partition_subexpression = variable_expression("x")

        expect(reduce).to include(
          reduction_results(
            same_expression_as(expected_reduced_expression),
            sum_partition(0, same_expression_as(expected_sum_partition_subexpression)),
            factor_partition(9, same_expression_as(expected_factor_partition_subexpression))
          )
        )
      end
    end

    define_method(:map_reduction_analysis) do |from:, to:, input: from, output: to|
      allow(reducer)
        .to receive(:reduction_analysis)
        .with(input)
        .and_return(output)
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
