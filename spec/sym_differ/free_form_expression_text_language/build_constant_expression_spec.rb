# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/build_constant_expression"
require "sym_differ/constant_expression"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::BuildConstantExpression do
  describe "#execute" do
    subject(:execute) { described_class.new.execute([value]) }

    let(:value) { 1 }

    it { is_expected.to have_attributes(value: 1) }
  end
end
