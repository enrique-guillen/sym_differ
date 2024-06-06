# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_walker_visitor"

RSpec.describe SymDiffer::ExpressionWalkerVisitor do
  let(:walker) { described_class.new(yield_at_list) }

  let(:expression_factory) { sym_differ_expression_factory }

  let(:method_to_yield) { proc {} }

  describe "#visit_constant_expression" do
    let(:expression) { constant_expression(1) }

    context "when yield_at_list does not include constants" do
      let(:yield_at_list) { %i[] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_constant_expression(expression, &m) }
          .not_to yield_with_args(expression)
      end
    end

    context "when yield_at_list includes constants" do
      let(:yield_at_list) { %i[constants] }

      it "invokes the provided block with the provided expression" do
        expect { |m| walker.visit_constant_expression(expression, &m) }
          .to yield_with_args(expression)
      end
    end
  end

  describe "#visit_variable_expression" do
    let(:expression) { variable_expression(1) }

    context "when yield_at_list does not include variables" do
      let(:yield_at_list) { %i[] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_variable_expression(expression, &m) }
          .not_to yield_with_args(expression)
      end
    end

    context "when yield_at_list includes variables" do
      let(:yield_at_list) { %i[variables] }

      it "invokes the provided block with the provided expression" do
        expect { |m| walker.visit_variable_expression(expression, &m) }
          .to yield_with_args(expression)
      end
    end
  end

  describe "#visit_positive_expression" do
    subject(:visit_positive_expression) do
      walker.visit_positive_expression(expression, &method_to_yield)
    end

    before { allow(summand).to receive(:accept) }

    let(:expression) { positive_expression(summand) }
    let(:summand) { double(:summand) }

    context "when yield_at_list does not include positives" do
      let(:yield_at_list) { %i[] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_positive_expression(expression, &m) }
          .not_to yield_with_args(expression)
      end

      it "walks summand with the provided block" do
        visit_positive_expression
        expect(summand).to have_received(:accept).with(walker, &method_to_yield)
      end
    end

    context "when yield_at_list includes positives" do
      let(:yield_at_list) { %i[positives] }

      it "invokes the provided block with the provided expression" do
        expect { |m| walker.visit_positive_expression(expression, &m) }
          .to yield_with_args(expression)
      end
    end
  end

  describe "#visit_negate_expression" do
    subject(:visit_negate_expression) do
      walker.visit_negate_expression(expression, &method_to_yield)
    end

    before { allow(negated_expression).to receive(:accept) }

    let(:expression) { negate_expression(negated_expression) }
    let(:negated_expression) { double(:negated_expression) }

    context "when yield_at_list does not include negatives" do
      let(:yield_at_list) { %i[] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_negate_expression(expression, &m) }
          .not_to yield_with_args(expression)
      end

      it "walks negated_expression with the provided block" do
        visit_negate_expression
        expect(negated_expression).to have_received(:accept).with(walker, &method_to_yield)
      end
    end

    context "when yield_at_list includes negatives" do
      let(:yield_at_list) { %i[negatives] }

      it "invokes the provided block with the provided expression" do
        expect { |m| walker.visit_negate_expression(expression, &m) }
          .to yield_with_args(expression)
      end
    end
  end

  describe "#visit_sum_expression" do
    subject(:visit_sum_expression) do
      walker.visit_sum_expression(expression, &method_to_yield)
    end

    before do
      allow(expression_a).to receive(:accept)
      allow(expression_b).to receive(:accept)
    end

    let(:expression) { sum_expression(expression_a, expression_b) }
    let(:expression_a) { double(:expression_a) }
    let(:expression_b) { double(:expression_b) }

    context "when yield_at_list does not include sums" do
      let(:yield_at_list) { %i[] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_sum_expression(expression, &m) }
          .not_to yield_with_args(expression)
      end

      it "walks expression_a with the provided block" do
        visit_sum_expression
        expect(expression_a).to have_received(:accept).with(walker, &method_to_yield)
      end

      it "walks expression_b with the provided block" do
        visit_sum_expression
        expect(expression_b).to have_received(:accept).with(walker, &method_to_yield)
      end
    end

    context "when yield_at_list includes sums" do
      let(:yield_at_list) { %i[sums] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_sum_expression(expression, &m) }
          .to yield_with_args(expression)
      end
    end
  end

  describe "#visit_subtract_expression" do
    subject(:visit_subtract_expression) do
      walker.visit_subtract_expression(expression, &method_to_yield)
    end

    before do
      allow(minuend).to receive(:accept)
      allow(subtrahend).to receive(:accept)
    end

    let(:expression) { subtract_expression(minuend, subtrahend) }
    let(:minuend) { double(:minuend) }
    let(:subtrahend) { double(:subtrahend) }

    context "when yield_at_list does not include subtractions" do
      let(:yield_at_list) { %i[] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_subtract_expression(expression, &m) }
          .not_to yield_with_args(expression)
      end

      it "walks minuend with the provided block" do
        visit_subtract_expression
        expect(minuend).to have_received(:accept).with(walker, &method_to_yield)
      end

      it "walks subtrahend with the provided block" do
        visit_subtract_expression
        expect(subtrahend).to have_received(:accept).with(walker, &method_to_yield)
      end
    end

    context "when yield_at_list includes subtractions" do
      let(:yield_at_list) { %i[subtractions] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_subtract_expression(expression, &m) }
          .to yield_with_args(expression)
      end
    end
  end

  describe "#visit_multiplicate_expression" do
    subject(:visit_multiplicate_expression) do
      walker.visit_multiplicate_expression(expression, &method_to_yield)
    end

    before do
      allow(multiplicand).to receive(:accept)
      allow(multiplier).to receive(:accept)
    end

    let(:expression) { multiplicate_expression(multiplicand, multiplier) }
    let(:multiplicand) { double(:multiplicand) }
    let(:multiplier) { double(:multiplier) }

    context "when yield_at_list does not include multiplications" do
      let(:yield_at_list) { %i[] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_multiplicate_expression(expression, &m) }
          .not_to yield_with_args(expression)
      end

      it "walks expression_a with the provided block" do
        visit_multiplicate_expression
        expect(multiplicand).to have_received(:accept).with(walker, &method_to_yield)
      end

      it "walks expression_b with the provided block" do
        visit_multiplicate_expression
        expect(multiplier).to have_received(:accept).with(walker, &method_to_yield)
      end
    end

    context "when yield_at_list includes multiplications" do
      let(:yield_at_list) { %i[multiplications] }

      it "invokes the provided block with the provided expression" do
        expect { |m| walker.visit_multiplicate_expression(expression, &m) }
          .to yield_with_args(expression)
      end
    end
  end

  describe "#visit_divide_expression" do
    subject(:visit_divide_expression) do
      walker.visit_divide_expression(expression, &method_to_yield)
    end

    before do
      allow(numerator).to receive(:accept)
      allow(denominator).to receive(:accept)
    end

    let(:expression) { divide_expression(numerator, denominator) }
    let(:numerator) { double(:numerator) }
    let(:denominator) { double(:denominator) }

    context "when yield_at_list does not include divisions" do
      let(:yield_at_list) { %i[] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_divide_expression(expression, &m) }
          .not_to yield_with_args(expression)
      end

      it "walks numerator with the provided block" do
        visit_divide_expression
        expect(numerator).to have_received(:accept).with(walker, &method_to_yield)
      end

      it "walks denominator with the provided block" do
        visit_divide_expression
        expect(denominator).to have_received(:accept).with(walker, &method_to_yield)
      end
    end

    context "when yield_at_list includes divisions" do
      let(:yield_at_list) { %i[divisions] }

      it "invokes the provided block with the provided expression" do
        expect { |m| walker.visit_divide_expression(expression, &m) }
          .to yield_with_args(expression)
      end
    end
  end

  describe "#visit_exponentiate_expression" do
    subject(:visit_exponentiate_expression) do
      walker.visit_exponentiate_expression(expression, &method_to_yield)
    end

    before do
      allow(base).to receive(:accept)
      allow(power).to receive(:accept)
    end

    let(:expression) { exponentiate_expression(base, power) }
    let(:base) { double(:base) }
    let(:power) { double(:power) }

    context "when yield_at_list does not include exponentiation" do
      let(:yield_at_list) { %i[] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_exponentiate_expression(expression, &m) }
          .not_to yield_with_args(expression)
      end

      it "walks base with the provided block" do
        visit_exponentiate_expression
        expect(base).to have_received(:accept).with(walker, &method_to_yield)
      end

      it "walks power with the provided block" do
        visit_exponentiate_expression
        expect(power).to have_received(:accept).with(walker, &method_to_yield)
      end
    end

    context "when yield_at_list includes exponentiations" do
      let(:yield_at_list) { %i[exponentiations] }

      it "invokes the provided block with the provided expression" do
        expect { |m| walker.visit_exponentiate_expression(expression, &m) }
          .to yield_with_args(expression)
      end
    end
  end

  describe "#visit_sine_expression" do
    subject(:visit_sine_expression) do
      walker.visit_sine_expression(expression, &method_to_yield)
    end

    before { allow(angle_expression).to receive(:accept) }

    let(:expression) { sine_expression(angle_expression) }
    let(:angle_expression) { double(:angle_expression) }

    context "when yield_at_list does not include sines" do
      let(:yield_at_list) { %i[] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_sine_expression(expression, &m) }
          .not_to yield_with_args(expression)
      end

      it "walks angle_expression with the provided block" do
        visit_sine_expression
        expect(angle_expression).to have_received(:accept).with(walker, &method_to_yield)
      end
    end

    context "when yield_at_list includes sines" do
      let(:yield_at_list) { %i[sines] }

      it "invokes the provided block with the provided expression" do
        expect { |m| walker.visit_sine_expression(expression, &m) }
          .to yield_with_args(expression)
      end
    end
  end

  describe "#visit_cosine_expression" do
    subject(:visit_cosine_expression) do
      walker.visit_cosine_expression(expression, &method_to_yield)
    end

    before { allow(angle_expression).to receive(:accept) }

    let(:expression) { cosine_expression(angle_expression) }
    let(:angle_expression) { double(:angle_expression) }

    context "when yield_at_list does not include cosines" do
      let(:yield_at_list) { %i[] }

      it "does not invoke the provided block with the provided expression" do
        expect { |m| walker.visit_cosine_expression(expression, &m) }
          .not_to yield_with_args(expression)
      end

      it "walks angle_expression with the provided block" do
        visit_cosine_expression
        expect(angle_expression).to have_received(:accept).with(walker, &method_to_yield)
      end
    end

    context "when yield_at_list includes cosines" do
      let(:yield_at_list) { %i[cosines] }

      it "invokes the provided block with the provided expression" do
        expect { |m| walker.visit_cosine_expression(expression, &m) }
          .to yield_with_args(expression)
      end
    end
  end

  describe "#visit_euler_number_expression" do
    let(:expression) { euler_number_expression }

    let(:yield_at_list) { %i[euler_numbers] }

    it "invokes the provided block with the provided expression" do
      expect { |m| walker.visit_euler_number_expression(expression, &m) }
        .to yield_with_args(expression)
    end
  end

  describe "#visit_natural_logarithm_expression" do
    subject(:visit_natural_logarithm_expression) do
      walker.visit_natural_logarithm_expression(expression, &method_to_yield)
    end

    before { allow(power_expression).to receive(:accept) }

    let(:expression) { natural_logarithm_expression(power_expression) }
    let(:power_expression) { double(:power_expression) }

    let(:yield_at_list) { %i[natural_logarithms] }

    it "invokes the provided block with the provided expression" do
      expect { |m| walker.visit_natural_logarithm_expression(expression, &m) }
        .to yield_with_args(expression)
    end

    it "walks power_expression with the provided block" do
      visit_natural_logarithm_expression
      expect(power_expression).to have_received(:accept).with(walker, &method_to_yield)
    end
  end

  describe "#walk" do
    subject(:walk) do
      walker.walk(expression, yield_at: %i[sines cosines], &method_to_yield)
    end

    before { allow(expression).to receive(:accept) }

    let(:yield_at_list) { [] }

    let(:expression) { double(:expression) }

    it "walks the provided expression" do
      walk
      expect(expression).to have_received(:accept).with(walker, &method_to_yield)
    end

    it "resets the yield_at_list to the provided values" do
      walk
      expect(walker.yield_at_list).to eq(%i[sines cosines].to_set)
    end
  end
end
