# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/build_subtract_expression_command"
require "sym_differ/subtract_expression"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::BuildSubtractExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new.execute([minuend, subtrahend]) }

    let(:minuend) { double(:minuend) }
    let(:subtrahend) { double(:subtrahend) }

    it { is_expected.to have_attributes(minuend:, subtrahend:) }
  end
end
