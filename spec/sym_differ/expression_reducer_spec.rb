# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reducer"
require "sym_differ/constant_expression"
require "sym_differ/sum_expression"
require "sym_differ/variable_expression"
require "sym_differ/subtract_expression"

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

    context "when the expression is <Subtract:<0>,<0>>" do
      let(:expression) { subtract_expression(constant_expression(0), constant_expression(0)) }

      it "returns the 0 constant" do
        expect(reduce).to have_attributes(value: 0)
      end
    end

    context "when the expression is <Subtract:<1>,<0>>" do
      let(:expression) { subtract_expression(constant_expression(1), constant_expression(0)) }

      it "returns the 1 constant" do
        expect(reduce).to have_attributes(value: 1)
      end
    end

    context "when the expression is <Subtract:<x>,<0>>" do
      let(:expression) { subtract_expression(variable_expression("x"), constant_expression(0)) }

      it "returns the x variable" do
        expect(reduce).to have_attributes(name: "x")
      end
    end

    context "when the expression is <Subtract:<0>,<1>>" do
      let(:expression) { subtract_expression(constant_expression(0), constant_expression(1)) }

      it "returns the expression tree representing -1" do
        expect(reduce).to have_attributes(negated_expression: an_object_having_attributes(value: 1))
      end
    end

    context "when the expression is <Subtract:<0>,<x>>" do
      let(:expression) { subtract_expression(constant_expression(0), variable_expression("x")) }

      it "returns the negated x variable" do
        expect(reduce).to have_attributes(negated_expression: an_object_having_attributes(name: "x"))
      end
    end

    context "when the expression is <Subtract: <Sum:<x>, <x>>, <1>>" do
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { sum_expression(variable_expression("x"), variable_expression("x")) }
      let(:subtrahend) { constant_expression(1) }

      it "returns an expression representing x + x -1" do
        expect(reduce).to have_attributes(
          minuend: an_object_having_attributes(
            expression_a: an_object_having_attributes(name: "x"),
            expression_b: an_object_having_attributes(name: "x")
          ),
          subtrahend: an_object_having_attributes(value: 1)
        )
      end
    end

    context "when the expression is <Subtract: <Sum:<x, 1>>, <Subtract: <1, x>>>" do
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { sum_expression(variable_expression("x"), constant_expression(1)) }
      let(:subtrahend) { subtract_expression(constant_expression(1), variable_expression("x")) }

      it "returns an expression representing x + x" do
        expect(reduce).to have_attributes(
          expression_a: an_object_having_attributes(name: "x"),
          expression_b: an_object_having_attributes(name: "x")
        )
      end
    end

    context "when the expression is <Subtract: <Subtract:<1, 0>>, <Subtract: <0, 1>>>" do
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { sum_expression(constant_expression(1), constant_expression(0)) }
      let(:subtrahend) { subtract_expression(constant_expression(0), constant_expression(1)) }

      it "returns an expression representing 2" do
        expect(reduce).to have_attributes(value: 2)
      end
    end

    context "when the expression is <Subtract: <Constant: 1>, <Var: x>>" do
      let(:expression) { subtract_expression(constant_expression(1), variable_expression("x")) }

      it "returns an expression representing 2" do
        expect(reduce).to have_attributes(
          minuend: an_object_having_attributes(value: 1),
          subtrahend: an_object_having_attributes(name: "x")
        )
      end
    end

    context "when the expression is <Subtract: 0, <Subtract: 0, x>>" do
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { constant_expression(0) }
      let(:subtrahend) { subtract_expression(constant_expression(0), variable_expression("x")) }

      it "returns an expression x" do
        expect(reduce).to have_attributes(name: "x")
      end
    end

    context "when the expression is <Sum: 0, <Subtract: 0, x>>" do
      let(:expression) { sum_expression(minuend, subtrahend) }

      let(:minuend) { constant_expression(0) }
      let(:subtrahend) { subtract_expression(constant_expression(0), variable_expression("x")) }

      it "returns an expression x" do
        expect(reduce).to have_attributes(negated_expression: an_object_having_attributes(name: "x"))
      end
    end

    context "when the expression is <Negate:0>" do
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { constant_expression(0) }

      it "returns 0" do
        expect(reduce).to have_attributes(value: 0)
      end
    end

    context "when the expression is <Negate:x>" do
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { variable_expression("x") }

      it "returns x" do
        expect(reduce).to have_attributes(negated_expression: an_object_having_attributes(name: "x"))
      end
    end

    context "when the expression is <Negate:1>" do
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { constant_expression(1) }

      it "returns -1" do
        expect(reduce).to have_attributes(negated_expression: an_object_having_attributes(value: 1))
      end
    end

    context "when the expression is <Negate:<Negate:x>>" do
      let(:expression) { negate_expression(negate_expression(negated_expression)) }
      let(:negated_expression) { variable_expression("x") }

      it "returns x" do
        expect(reduce).to have_attributes(name: "x")
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

    define_method(:subtract_expression) do |expression_a, expression_b|
      SymDiffer::SubtractExpression.new(expression_a, expression_b)
    end

    define_method(:negate_expression) do |negated_expression|
      SymDiffer::NegateExpression.new(negated_expression)
    end
  end
end
