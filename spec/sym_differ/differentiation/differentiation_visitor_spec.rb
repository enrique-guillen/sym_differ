# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/differentiation_visitor"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::Differentiation::DifferentiationVisitor do
  let(:visitor) { described_class.new(variable, expression_factory) }

  let(:expression_factory) { SymDiffer::ExpressionFactory.new }

  describe "#visit_constant_expression" do
    subject(:visit_constant_expression) do
      visitor.visit_constant_expression(expression)
    end

    let(:expression) { constant_expression(0) }
    let(:variable) { "x" }

    it "returns the result of deriving the constant expression" do
      expect(visit_constant_expression).to have_attributes(value: 0)
    end
  end

  describe "#visit_variable_expression" do
    subject(:visit_variable_expression) do
      visitor.visit_variable_expression(expression)
    end

    let(:variable) { "x" }

    let(:expression) { variable_expression("x") }

    it "returns the result of deriving the variable expression" do
      expect(visit_variable_expression).to have_attributes(value: 1)
    end
  end

  describe "#visit_negate_expression" do
    subject(:visit_negate_expression) do
      visitor.visit_negate_expression(expression)
    end

    let(:variable) { "x" }

    context "when the expression to derive is -x" do
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { variable_expression("x") }

      it "returns the result of deriving the negate expression" do
        expect(visit_negate_expression).to have_attributes(negated_expression: an_object_having_attributes(value: 1))
      end
    end

    context "when the expression to derive is -2" do
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { constant_expression(2) }

      it "returns the result of deriving the negate expression" do
        expect(visit_negate_expression).to have_attributes(negated_expression: an_object_having_attributes(value: 0))
      end
    end
  end

  describe "#visit_sum_expression" do
    subject(:visit_sum_expression) do
      visitor.visit_sum_expression(expression)
    end

    let(:variable) { "x" }
    let(:expression) { sum_expression(expression_a, expression_b) }
    let(:expression_a) { variable_expression("var") }
    let(:expression_b) { variable_expression("x") }

    it "returns the result of deriving the sum expression" do
      expect(visit_sum_expression).to have_attributes(
        expression_a: an_object_having_attributes(value: 0),
        expression_b: an_object_having_attributes(value: 1)
      )
    end
  end

  describe "#visit_subtract_expression" do
    subject(:visit_subtract_expression) do
      visitor.visit_subtract_expression(expression)
    end

    let(:expression) { subtract_expression(minuend, subtrahend) }
    let(:variable) { "x" }

    let(:minuend) { variable_expression("x") }
    let(:subtrahend) { constant_expression(1) }

    it "returns the result of deriving the expression" do
      expect(visit_subtract_expression).to have_attributes(
        minuend: an_object_having_attributes(value: 1),
        subtrahend: an_object_having_attributes(value: 0)
      )
    end
  end

  describe "#visit_positive_expression" do
    subject(:visit_positive_expression) do
      visitor.visit_positive_expression(expression)
    end

    let(:variable) { "x" }
    let(:expression) { positive_expression(summand) }
    let(:summand) { variable_expression("x") }

    it "returns the result of deriving the expression" do
      expect(visit_positive_expression).to have_attributes(value: 1)
    end
  end

  describe "#visit_multiplicate_expression" do
    subject(:visit_multiplicate_expression) do
      visitor.visit_multiplicate_expression(expression)
    end

    let(:expression) { multiplicate_expression(multiplicand, multiplier) }
    let(:variable) { "x" }

    let(:multiplicand) { variable_expression("x") }
    let(:multiplier) { variable_expression("x") }

    it "returns the result of deriving the expression" do
      expect(visit_multiplicate_expression).to have_attributes(
        expression_a: an_object_having_attributes(multiplicand: an_object_having_attributes(value: 1),
                                                  multiplier: an_object_having_attributes(name: "x")),
        expression_b: an_object_having_attributes(multiplicand: an_object_having_attributes(name: "x"),
                                                  multiplier: an_object_having_attributes(value: 1))
      )
    end
  end

  define_method(:constant_expression) do |value|
    expression_factory.create_constant_expression(value)
  end

  define_method(:variable_expression) do |name|
    expression_factory.create_variable_expression(name)
  end

  define_method(:sum_expression) do |expression_a, expression_b|
    expression_factory.create_sum_expression(expression_a, expression_b)
  end

  define_method(:subtract_expression) do |expression_a, expression_b|
    expression_factory.create_subtract_expression(expression_a, expression_b)
  end

  define_method(:negate_expression) do |negated_expression|
    expression_factory.create_negate_expression(negated_expression)
  end

  define_method(:positive_expression) do |summand|
    expression_factory.create_positive_expression(summand)
  end

  define_method(:multiplicate_expression) do |multiplicand, multiplier|
    expression_factory.create_multiplicate_expression(multiplicand, multiplier)
  end
end
