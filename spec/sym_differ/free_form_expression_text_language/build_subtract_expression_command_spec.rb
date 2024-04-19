# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/build_subtract_expression_command"
require "sym_differ/subtract_expression"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::BuildSubtractExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new.execute(arguments) }

    context "when the arguments have two expressions" do
      let(:arguments) { [minuend, subtrahend] }

      let(:minuend) { double(:minuend) }
      let(:subtrahend) { double(:subtrahend) }

      it { is_expected.to have_attributes(minuend:, subtrahend:) }
    end

    context "when the arguments have only one expression" do
      let(:arguments) { [negated_expression] }

      let(:negated_expression) { double(:negated_expression) }

      it { is_expected.to have_attributes(negated_expression:) }
    end
  end
end
