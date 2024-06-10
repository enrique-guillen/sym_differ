# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_reduction/reducer_visitor"

require "sym_differ/expression_reduction/sum_partitioner_visitor"
require "sym_differ/expression_reduction/factor_partitioner_visitor"

RSpec.describe SymDiffer::ExpressionReduction::ReducerVisitor do
  before do
    sum_partitioner_visitor.expression_reducer = visitor
    sum_partitioner_visitor.factor_partitioner = factor_partitioner_visitor
  end

  let(:visitor) do
    described_class.new(
      expression_factory,
      sum_partitioner_visitor,
      factor_partitioner_visitor
    )
  end

  let(:sum_partitioner_visitor) do
    SymDiffer::ExpressionReduction::SumPartitionerVisitor
      .new(expression_factory)
  end

  let(:factor_partitioner_visitor) do
    SymDiffer::ExpressionReduction::FactorPartitionerVisitor
      .new(expression_factory, sum_partitioner_visitor)
  end

  let(:expression_factory) { sym_differ_expression_factory }

  describe "#reduce" do
    subject(:reduce) do
      visitor.reduce(expression)
    end

    context "when an expression is provided" do
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

    context "when the expression is 1 + 1 (clarification)" do
      let(:expression) { sum_expression(constant_expression(1), constant_expression(1)) }

      it { is_expected.to be_same_as(constant_expression(2)) }
    end

    context "when the expression is (1+1) + x (clarification)" do
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

    context "when the expression is 1+(x+1) (clarification)" do
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

    context "when the expression is 1 + (1 + x + 2) (clarification)" do
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

    context "when the expression is x+0 (clarification)" do
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

    context "when the expression is 1 + (1 + (x + (x + 1))) (clarification)" do
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

    context "when the expression is 0-0 (clarification)" do
      let(:expression) { subtract_expression(constant_expression(0), constant_expression(0)) }

      it "returns the 0 constant" do
        expect(reduce).to be_same_as(constant_expression(0))
      end
    end

    context "when the expression is 1-0 (clarification)" do
      let(:expression) { subtract_expression(constant_expression(1), constant_expression(0)) }

      it "returns the 1 constant" do
        expect(reduce).to be_same_as(constant_expression(1))
      end
    end

    context "when the expression is x-0 (clarification)" do
      let(:expression) { subtract_expression(variable_expression("x"), constant_expression(0)) }

      it "returns the x variable" do
        expect(reduce).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is 0-1 (clarification)" do
      let(:expression) { subtract_expression(constant_expression(0), constant_expression(1)) }

      it "returns the expression tree representing -1" do
        expect(reduce).to be_same_as(negate_expression(constant_expression(1)))
      end
    end

    context "when the expression is 0-x (clarification)" do
      let(:expression) { subtract_expression(constant_expression(0), variable_expression("x")) }

      it "returns the negated x variable" do
        expect(reduce).to be_same_as(negate_expression(variable_expression("x")))
      end
    end

    context "when the expression is x+1-1 (clarification)" do
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

    context "when the expression is x + 1 - (1-x) (clarification)" do
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { sum_expression(variable_expression("x"), constant_expression(1)) }
      let(:subtrahend) { subtract_expression(constant_expression(1), variable_expression("x")) }

      it "returns an expression representing x + x" do
        expect(reduce).to be_same_as(
          sum_expression(variable_expression("x"), variable_expression("x"))
        )
      end
    end

    context "when the expression is 1-0-(0-1) (clarification)" do
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { sum_expression(constant_expression(1), constant_expression(0)) }
      let(:subtrahend) { subtract_expression(constant_expression(0), constant_expression(1)) }

      it "returns an expression representing 2" do
        expect(reduce).to be_same_as(constant_expression(2))
      end
    end

    context "when the expression is 1- x (clarification)" do
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

    context "when the expression is 0 - (0 -x) (clarification)" do
      let(:expression) { subtract_expression(minuend, subtrahend) }

      let(:minuend) { constant_expression(0) }
      let(:subtrahend) { subtract_expression(constant_expression(0), variable_expression("x")) }

      it "returns an expression x" do
        expect(reduce).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is 0 + 0 - x (clarification)" do
      let(:expression) { sum_expression(minuend, subtrahend) }

      let(:minuend) { constant_expression(0) }
      let(:subtrahend) { subtract_expression(constant_expression(0), variable_expression("x")) }

      it "returns an expression x" do
        expect(reduce).to be_same_as(negate_expression(variable_expression("x")))
      end
    end

    context "when the expression is -0 (clarification)" do
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { constant_expression(0) }

      it "returns 0" do
        expect(reduce).to be_same_as(constant_expression(0))
      end
    end

    context "when the expression is -x (clarification)" do
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { variable_expression("x") }

      it "returns x" do
        expect(reduce).to be_same_as(negate_expression(variable_expression("x")))
      end
    end

    context "when the expression is -1 (clarification)" do
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { constant_expression(1) }

      it "returns -1" do
        expect(reduce).to be_same_as(negate_expression(constant_expression(1)))
      end
    end

    context "when the expression is --x (clarification)" do
      let(:expression) { negate_expression(negate_expression(negated_expression)) }
      let(:negated_expression) { variable_expression("x") }

      it "returns x" do
        expect(reduce).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is +x (clarification)" do
      let(:expression) { positive_expression(negated_expression) }
      let(:negated_expression) { variable_expression("x") }

      it "returns x" do
        expect(reduce).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is ++x (clarification)" do
      let(:expression) { positive_expression(positive_expression(negated_expression)) }
      let(:negated_expression) { variable_expression("x") }

      it "returns x" do
        expect(reduce).to be_same_as(variable_expression("x"))
      end
    end

    context "when the expression is 1 + +1 (clarification)" do
      let(:expression) { sum_expression(constant_expression(1), positive_expression(constant_expression(1))) }

      it "returns 2" do
        expect(reduce).to be_same_as(constant_expression(2))
      end
    end

    context "when the expression is 1 * x + x * 1 (clarification)" do
      let(:expression) { sum_expression(expression_a, expression_b) }
      let(:expression_a) { multiplicate_expression(constant_expression(1), variable_expression("x")) }
      let(:expression_b) { multiplicate_expression(variable_expression("x"), constant_expression(1)) }

      it "returns x + x" do
        expect(reduce).to be_same_as(
          sum_expression(variable_expression("x"), variable_expression("x"))
        )
      end
    end

    context "when the expression is (1 + 1) / (2 + 2) (clarification)" do
      let(:expression) { divide_expression(expression_a, expression_b) }
      let(:expression_a) { sum_expression(constant_expression(1), constant_expression(1)) }
      let(:expression_b) { sum_expression(constant_expression(2), constant_expression(2)) }

      it "returns 2 / 4" do
        expect(reduce).to be_same_as(
          divide_expression(constant_expression(2), constant_expression(4))
        )
      end
    end
  end

  describe "#visit_constant_expression" do
    subject(:visit_constant_expression) do
      visitor.visit_constant_expression(expression)
    end

    let(:expression) { constant_expression(1) }

    it { is_expected.to be_same_as(constant_expression(1)) }
  end

  describe "#visit_variable_expression" do
    subject(:visit_variable_expression) do
      visitor.visit_variable_expression(expression)
    end

    let(:expression) { variable_expression("x") }

    it { is_expected.to be_same_as(variable_expression("x")) }
  end

  describe "#visit_positive_expression" do
    subject(:visit_positive_expression) do
      visitor.visit_positive_expression(expression)
    end

    let(:expression) { positive_expression(variable_expression("x")) }

    it { is_expected.to be_same_as(variable_expression("x")) }
  end

  describe "#visit_negate_expression" do
    subject(:visit_negate_expression) do
      visitor.visit_negate_expression(expression)
    end

    let(:expression) { negate_expression(variable_expression("x")) }

    it { is_expected.to be_same_as(negate_expression(variable_expression("x"))) }
  end

  describe "#visit_sum_expression" do
    subject(:visit_sum_expression) do
      visitor.visit_sum_expression(expression)
    end

    let(:expression) { sum_expression(constant_expression(1), constant_expression(1)) }

    it { is_expected.to be_same_as(constant_expression(2)) }
  end

  describe "#visit_subtract_expression" do
    subject(:visit_subtract_expression) do
      visitor.visit_subtract_expression(expression)
    end

    let(:expression) { subtract_expression(constant_expression(1), constant_expression(1)) }

    it { is_expected.to be_same_as(constant_expression(0)) }
  end

  describe "#visit_multiplicate_expression" do
    subject(:visit_multiplicate_expression) do
      visitor.visit_multiplicate_expression(expression)
    end

    let(:expression) { multiplicate_expression(constant_expression(2), constant_expression(2)) }

    it { is_expected.to be_same_as(constant_expression(4)) }
  end

  describe "#visit_divide_expression" do
    subject(:visit_divide_expression) do
      visitor.visit_divide_expression(expression)
    end

    let(:expression) { divide_expression(constant_expression(4), constant_expression(2)) }

    it { is_expected.to be_same_as(divide_expression(constant_expression(4), constant_expression(2))) }
  end

  describe "#visit_exponentiate_expression" do
    subject(:visit_exponentiate_expression) do
      visitor.visit_exponentiate_expression(expression)
    end

    let(:expression) { exponentiate_expression(constant_expression(4), constant_expression(2)) }

    it { is_expected.to be_same_as(constant_expression(16)) }
  end
end
