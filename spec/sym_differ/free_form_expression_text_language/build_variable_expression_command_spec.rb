# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/build_variable_expression_command"
require "sym_differ/variable_expression"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::BuildVariableExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new.execute([name]) }

    let(:name) { "x" }

    it { is_expected.to have_attributes(name: "x") }
  end
end
