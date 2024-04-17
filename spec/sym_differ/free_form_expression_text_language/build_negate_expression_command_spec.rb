# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/build_negate_expression_command"
require "sym_differ/negate_expression"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::BuildNegateExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new.execute([negated_expression]) }

    let(:negated_expression) { double(:negated_expression) }

    it { is_expected.to have_attributes(negated_expression:) }
  end
end
