# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reducer"
require "sym_differ/constant_expression"
require "sym_differ/sum_expression"
require "sym_differ/variable_expression"

RSpec.describe SymDiffer::ExpressionReducer do
  describe "#reduce" do
    subject(:reduce) { described_class.new.reduce(expression) }

    context "when the expression is <ConstantExpression:1>" do
      let(:expression) { constant_expression(1) }

      it { is_expected.to have_attributes(value: 1) }
    end

    context "when the expression is <SumExpression:<ConstantExpression:1>,<ConstantExpression:1>>" do
      let(:expression) do
        sum_expression(constant_expression(1), constant_expression(1))
      end

      it { is_expected.to have_attributes(value: 2) }
    end

    context "when the expression is <SumExpression:" \
            "<SumExpression:<<ConstantExpression:1>,<ConstantExpression:1>>," \
            "<VariableExpression:x>>" do
      let(:expression) do
        sum_expression(expression_a, expression_b)
      end

      let(:expression_a) do
        sum_expression(constant_expression(1), constant_expression(1))
      end

      let(:expression_b) { variable_expression("x") }

      it "returns the expected reduction" do
        expect(reduce).to have_attributes(
          expression_a: an_object_having_attributes(name: "x"),
          expression_b: an_object_having_attributes(value: 2)
        )
      end
    end

    context "when the expression is <SumExpression:" \
            "<ConstantExpression:1>," \
            "<SumExpression:<VariableExpression:x>,<ConstantExpression:1>>>" do
      let(:expression) { sum_expression(expression_a, expression_b) }

      let(:expression_a) do
        constant_expression(1)
      end

      let(:expression_b) do
        sum_expression(variable_expression("x"), constant_expression(1))
      end

      it "returns the expected reduction" do
        expect(reduce).to have_attributes(
          expression_a: an_object_having_attributes(name: "x"),
          expression_b: an_object_having_attributes(value: 2)
        )
      end
    end

    context "when the expression is <SumExpression:" \
            "<ConstantExpression:1>" \
            "<SumExpression:<ConstantExpression:1>,<SumExpression:<VariableExpression:x>,<ConstantExpression:2>>>," \
            ">" do
      let(:expression) { sum_expression(expression_a, expression_b) }

      let(:expression_a) do
        constant_expression(1)
      end

      let(:expression_b) do
        sum_expression(
          constant_expression(1),
          sum_expression(variable_expression("x"), constant_expression(2))
        )
      end

      it "returns the expected reduction" do
        expect(reduce).to have_attributes(
          expression_a: an_object_having_attributes(name: "x"),
          expression_b: an_object_having_attributes(value: 4)
        )
      end
    end

    context "when the expression is <SumExpression:" \
            "<VariableExpression:x>, <ConstantExpression:0>" \
            ">" do
      let(:expression) { sum_expression(expression_a, expression_b) }

      let(:expression_a) do
        variable_expression("x")
      end

      let(:expression_b) do
        constant_expression(0)
      end

      it "returns the expected reduction" do
        expect(reduce).to have_attributes(name: "x")
      end
    end

    context "when the expression is <SumExpression:" \
            "<ConstantExpression:1>" \
            "<SumExpression:" \
            "<ConstantExpression:1>," \
            "<SumExpression:" \
            "<VariableExpression:x>," \
            "<SumExpression:<VariableExpression:x>,<ConstantExpression:1>>>>," \
            ">" do
      let(:expression) { sum_expression(expression_a, expression_b) }

      let(:expression_a) do
        constant_expression(1)
      end

      let(:expression_b) do
        sum_expression(
          constant_expression(1),
          sum_expression(
            variable_expression("x"),
            sum_expression(variable_expression("x"), constant_expression(1))
          )
        )
      end

      it "returns the expected reduction" do
        expect(reduce).to have_attributes(
          expression_a: an_object_having_attributes(
            expression_a: an_object_having_attributes(name: "x"),
            expression_b: an_object_having_attributes(name: "x")
          ),
          expression_b: an_object_having_attributes(value: 3)
        )
      end
    end
  end

  define_method(:constant_expression) do |value|
    SymDiffer::ConstantExpression.new(value)
  end

  define_method(:variable_expression) do |name|
    SymDiffer::VariableExpression.new(name)
  end

  define_method(:sum_expression) do |expression_a, expression_b|
    SymDiffer::SumExpression.new(expression_a, expression_b)
  end
end
