# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reducer"
require "sym_differ/expression_factory"

RSpec.describe SymDiffer::ExpressionReducer do
  describe "#reduce" do
    subject(:reduce) { described_class.new(expression_factory).reduce(expression) }

    let(:expression_factory) { SymDiffer::ExpressionFactory.new }

    context "when the expression is 1" do
      let(:expression) { constant_expression(1) }

      it { is_expected.to be_same_as(constant_expression(1)) }
    end

    context "when the expression is 1+1" do
      let(:expression) do
        sum_expression(constant_expression(1), constant_expression(1))
      end

      it { is_expected.to be_same_as(constant_expression(2)) }
    end

    context "when the expression is (1+1)+x" do
      let(:expression) do
        sum_expression(expression_a, expression_b)
      end

      let(:expression_a) do
        sum_expression(constant_expression(1), constant_expression(1))
      end

      let(:expression_b) { variable_expression("x") }

      it "returns the expected reduction" do
        expect(reduce).to be_same_as(
          sum_expression(
            variable_expression("x"),
            constant_expression(2)
          )
        )
      end
    end

    context "when the expression is 1+(x+1)" do
      let(:expression) { sum_expression(expression_a, expression_b) }

      let(:expression_a) do
        constant_expression(1)
      end

      let(:expression_b) do
        sum_expression(variable_expression("x"), constant_expression(1))
      end

      it "returns the expected reduction" do
        expect(reduce).to be_same_as(
          sum_expression(
            variable_expression("x"),
            constant_expression(2)
          )
        )
      end
    end

    context "when the expression is 1 + (1 + x + 2)" do
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
        expect(reduce).to be_same_as(
          sum_expression(
            variable_expression("x"),
            constant_expression(4)
          )
        )
      end
    end

    context "when the expression is x+0" do
      let(:expression) { sum_expression(expression_a, expression_b) }

      let(:expression_a) do
        variable_expression("x")
      end

      let(:expression_b) do
        constant_expression(0)
      end

      it "returns the expected reduction" do
        expect(reduce).to have_attributes(name: "x")

        expect(reduce).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is 1 + (1 + (x + (x + 1)))" do
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
        expect(reduce).to be_same_as(
          sum_expression(
            sum_expression(variable_expression("x"), variable_expression("x")),
            constant_expression(3)
          )
        )
      end
    end

    context "when the expression is 0-0" do
      let(:expression) { subtract_expression(constant_expression(0), constant_expression(0)) }

      it "returns the 0 constant" do
        expect(reduce).to be_same_as(constant_expression(0))
      end
    end

    context "when the expression is 1-0" do
      let(:expression) { subtract_expression(constant_expression(1), constant_expression(0)) }

      it "returns the 1 constant" do
        expect(reduce).to be_same_as(constant_expression(1))
      end
    end

    context "when the expression is x-0" do
      let(:expression) { subtract_expression(variable_expression("x"), constant_expression(0)) }

      it "returns the x variable" do
        expect(reduce).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is 0-1" do
      let(:expression) { subtract_expression(constant_expression(0), constant_expression(1)) }

      it "returns the expression tree representing -1" do
        expect(reduce).to be_same_as(negate_expression(constant_expression(1)))
      end
    end

    context "when the expression is 0-x" do
      let(:expression) { subtract_expression(constant_expression(0), variable_expression("x")) }

      it "returns the negated x variable" do
        expect(reduce).to be_same_as(negate_expression(variable_expression("x")))
      end
    end

    context "when the expression is x+1-1" do
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { sum_expression(variable_expression("x"), variable_expression("x")) }
      let(:subtrahend) { constant_expression(1) }

      it "returns an expression representing x + x - 1" do
        expect(reduce).to be_same_as(
          subtract_expression(
            sum_expression(variable_expression("x"), variable_expression("x")),
            constant_expression(1)
          )
        )
      end
    end

    context "when the expression is x + 1 - (1-x)" do
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { sum_expression(variable_expression("x"), constant_expression(1)) }
      let(:subtrahend) { subtract_expression(constant_expression(1), variable_expression("x")) }

      it "returns an expression representing x + x" do
        expect(reduce).to be_same_as(
          sum_expression(variable_expression("x"), variable_expression("x"))
        )
      end
    end

    context "when the expression is 1-0-(0-1)" do
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { sum_expression(constant_expression(1), constant_expression(0)) }
      let(:subtrahend) { subtract_expression(constant_expression(0), constant_expression(1)) }

      it "returns an expression representing 2" do
        expect(reduce).to be_same_as(constant_expression(2))
      end
    end

    context "when the expression is 1- x" do
      let(:expression) { subtract_expression(constant_expression(1), variable_expression("x")) }

      it "returns an expression representing -x + 1" do
        expect(reduce).to be_same_as(
          sum_expression(
            negate_expression(variable_expression("x")),
            constant_expression(1)
          )
        )
      end
    end

    context "when the expression is 0 - (0 -x)" do
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { constant_expression(0) }
      let(:subtrahend) { subtract_expression(constant_expression(0), variable_expression("x")) }

      it "returns an expression x" do
        expect(reduce).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is 0 + 0 - x" do
      let(:expression) { sum_expression(minuend, subtrahend) }

      let(:minuend) { constant_expression(0) }
      let(:subtrahend) { subtract_expression(constant_expression(0), variable_expression("x")) }

      it "returns an expression x" do
        expect(reduce).to be_same_as(negate_expression(variable_expression("x")))
      end
    end

    context "when the expression is -0" do
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { constant_expression(0) }

      it "returns 0" do
        expect(reduce).to be_same_as(constant_expression(0))
      end
    end

    context "when the expression is -x" do
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { variable_expression("x") }

      it "returns x" do
        expect(reduce).to be_same_as(negate_expression(variable_expression("x")))
      end
    end

    context "when the expression is -1" do
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { constant_expression(1) }

      it "returns -1" do
        expect(reduce).to be_same_as(negate_expression(constant_expression(1)))
      end
    end

    context "when the expression is --x" do
      let(:expression) { negate_expression(negate_expression(negated_expression)) }
      let(:negated_expression) { variable_expression("x") }

      it "returns x" do
        expect(reduce).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is +x" do
      let(:expression) { positive_expression(negated_expression) }
      let(:negated_expression) { variable_expression("x") }

      it "returns x" do
        expect(reduce).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is ++x" do
      let(:expression) { positive_expression(positive_expression(negated_expression)) }
      let(:negated_expression) { variable_expression("x") }

      it "returns x" do
        expect(reduce).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is 1 + +1" do
      let(:expression) { sum_expression(constant_expression(1), positive_expression(constant_expression(1))) }

      it "returns 2" do
        expect(reduce).to be_same_as(constant_expression(2))
      end
    end

    context "when the expression is 1 * x + x * 1" do
      let(:expression) { sum_expression(expression_a, expression_b) }
      let(:expression_a) { multiplicate_expression(constant_expression(1), variable_expression("x")) }
      let(:expression_b) { multiplicate_expression(variable_expression("x"), constant_expression(1)) }

      it "returns x + x" do
        expect(reduce).to be_same_as(
          sum_expression(variable_expression("x"), variable_expression("x"))
        )
      end
    end
  end
end
