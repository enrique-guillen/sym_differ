# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/differentiation_visitor"

require "sym_differ/expression_factory"

RSpec.describe SymDiffer::Differentiation::DifferentiationVisitor do
  let(:visitor) { described_class.new(variable, expression_factory) }

  let(:expression_factory) { sym_differ_expression_factory }

  describe "#visit_constant_expression" do
    subject(:visit_constant_expression) do
      visitor.visit_constant_expression(expression)
    end

    let(:expression) { constant_expression(0) }
    let(:variable) { "x" }

    it "returns the result of deriving the constant expression" do
      expect(visit_constant_expression).to be_same_as(constant_expression(0))
    end
  end

  describe "#visit_variable_expression" do
    subject(:visit_variable_expression) do
      visitor.visit_variable_expression(expression)
    end

    let(:variable) { "x" }

    let(:expression) { variable_expression("x") }

    it "returns the result of deriving the variable expression" do
      expect(visit_variable_expression).to be_same_as(constant_expression(1))
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
        expect(visit_negate_expression).to be_same_as(negate_expression(constant_expression(1)))
      end
    end

    context "when the expression to derive is -2" do
      let(:expression) { negate_expression(negated_expression) }
      let(:negated_expression) { constant_expression(2) }

      it "returns the result of deriving the negate expression" do
        expect(visit_negate_expression).to be_same_as(negate_expression(constant_expression(0)))
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
      expect(visit_sum_expression).to be_same_as(
        sum_expression(constant_expression(0), constant_expression(1))
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
      expect(visit_subtract_expression).to be_same_as(
        subtract_expression(constant_expression(1), constant_expression(0))
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
      expect(visit_positive_expression).to be_same_as(constant_expression(1))
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
      expect(visit_multiplicate_expression).to be_same_as(
        sum_expression(
          multiplicate_expression(constant_expression(1), variable_expression("x")),
          multiplicate_expression(variable_expression("x"), constant_expression(1))
        )
      )
    end
  end

  describe "#visit_sine_expression" do
    subject(:visit_sine_expression) do
      visitor.visit_sine_expression(expression)
    end

    let(:expression) { sine_expression(angle_expression) }
    let(:angle_expression) { variable_expression("x") }
    let(:variable) { "x" }

    it "returns the result of deriving the expression" do
      expect(visit_sine_expression).to be_same_as(
        multiplicate_expression(
          cosine_expression(variable_expression("x")),
          constant_expression(1)
        )
      )
    end
  end

  describe "#visit_cosine_expression" do
    subject(:visit_cosine_expression) do
      visitor.visit_cosine_expression(expression)
    end

    let(:expression) { cosine_expression(angle_expression) }
    let(:angle_expression) { variable_expression("x") }
    let(:variable) { "x" }

    it "returns the result of deriving the expression" do
      expect(visit_cosine_expression).to be_same_as(
        multiplicate_expression(
          negate_expression(sine_expression(variable_expression("x"))),
          constant_expression(1)
        )
      )
    end
  end

  describe "#visit_divide_expression" do
    subject(:visit_divide_expression) do
      visitor.visit_divide_expression(expression)
    end

    let(:expression) { divide_expression(numerator_expression, denominator_expression) }
    let(:variable) { "x" }

    let(:numerator_expression) { sine_expression(variable_expression("x")) }
    let(:denominator_expression) { variable_expression("x") }

    it "returns the result of deriving the expression" do
      expect(visit_divide_expression).to be_same_as(
        divide_expression(
          subtract_expression(
            multiplicate_expression(
              multiplicate_expression(cosine_expression(variable_expression("x")), constant_expression(1)),
              variable_expression("x")
            ),
            multiplicate_expression(sine_expression(variable_expression("x")), constant_expression(1))
          ),
          exponentiate_expression(variable_expression("x"), constant_expression(2))
        )
      )
    end
  end

  describe "#visit_natural_logarithm_expression" do
    subject(:visit_natural_logarithm_expression) do
      visitor.visit_natural_logarithm_expression(expression)
    end

    let(:expression) { natural_logarithm_expression(power_expression) }
    let(:variable) { "x" }

    let(:power_expression) { variable_expression("x") }

    it "returns the result of deriving the expression" do
      expect(visit_natural_logarithm_expression).to be_same_as(
        divide_expression(
          constant_expression(1),
          variable_expression("x")
        )
      )
    end
  end

  describe "#visit_exponentiate_expression" do
    subject(:visit_exponentiate_expression) do
      visitor.visit_exponentiate_expression(expression)
    end

    let(:expression) { exponentiate_expression(variable_expression("x"), constant_expression(2)) }
    let(:variable) { "x" }

    it "returns the result of deriving the expression" do
      expect(visit_exponentiate_expression).to be_same_as(
        multiplicate_expression(
          multiplicate_expression(
            constant_expression(2),
            exponentiate_expression(
              variable_expression("x"),
              subtract_expression(constant_expression(2), constant_expression(1))
            )
          ),
          constant_expression(1)
        )
      )
    end
  end

  describe "#visit_abstract_expression" do
    subject(:visit_abstract_expression) do
      visitor.visit_abstract_expression(expression)
    end

    let(:expression) { variable_expression("x") }
    let(:variable) { "x" }

    it "returns the result wrapped in an unevaluated derivative expression" do
      expect(visit_abstract_expression).to be_same_as(
        derivative_expression(expression, variable_expression(variable))
      )
    end
  end
end
