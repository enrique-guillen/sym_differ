# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation/exponentiate_expression_deriver"

RSpec.describe SymDiffer::Differentiation::ExponentiateExpressionDeriver do
  describe "#derive" do
    subject(:derive) do
      described_class
        .new(differentiation_visitor, expression_walker, expression_factory)
        .derive(expression, variable)
    end

    let(:differentiation_visitor) { double(:differentiation_visitor) }
    let(:expression_walker) { double(:expression_walker) }
    let(:expression_factory) { sym_differ_expression_factory }

    let(:expression) { exponentiate_expression(base, power) }
    let(:variable) { "x" }

    context "when the power is a constant" do
      before do
        allow(expression_walker)
          .to receive(:walk)
          .with(power, yield_at: %i[variables])

        allow(differentiation_visitor)
          .to receive(:derive)
          .with(base)
          .and_return(base_derivative)
      end

      let(:base) { expression_test_double(:base) }
      let(:power) { constant_expression(5) }
      let(:base_derivative) { expression_test_double(:base_derivative) }

      it "returns the derivative of a function raised to a constant" do
        expect(derive).to be_same_as(
          multiplicate_expression(
            multiplicate_expression(
              constant_expression(5),
              exponentiate_expression(base, subtract_expression(constant_expression(5), constant_expression(1)))
            ),
            base_derivative
          )
        )
      end
    end

    context "when the base is the euler number expression" do
      before do
        allow(expression_walker)
          .to receive(:walk)
          .with(power, yield_at: %i[variables])
          .and_yield(variable_expression("x"))

        allow(differentiation_visitor)
          .to receive(:derive)
          .with(power)
          .and_return(power_derivative)
      end

      let(:base) { euler_number_expression }
      let(:power) { expression_test_double(:power) }
      let(:power_derivative) { expression_test_double(:power_derivative) }

      it "returns the derivative of euler raised to an expression" do
        expect(derive).to be_same_as(
          multiplicate_expression(
            exponentiate_expression(euler_number_expression, power),
            power_derivative
          )
        )
      end
    end

    context "when both base and power are arbitrary expressions" do
      before do
        allow(expression_walker)
          .to receive(:walk)
          .with(power, yield_at: %i[variables])
          .and_yield(variable_expression("x"))

        allow(differentiation_visitor)
          .to receive(:derive)
          .with(
            same_expression_as(
              exponentiate_expression(
                euler_number_expression,
                multiplicate_expression(
                  power,
                  natural_logarithm_expression(base)
                )
              )
            )
          )
          .and_return(arbitrary_exponentiation_expression_derivative)
      end

      let(:base) { expression_test_double(:expression) }
      let(:power) { expression_test_double(:power) }

      let(:arbitrary_exponentiation_expression_derivative) do
        expression_test_double(:arbitrary_exponentiation_expression_derivative)
      end

      it "returns the derivative of the natural logarithm of the euler number raised to the given expression" do
        expect(derive).to be_same_as(
          arbitrary_exponentiation_expression_derivative
        )
      end
    end
  end
end
