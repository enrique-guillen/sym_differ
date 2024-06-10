# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/invalid_variable_given_to_expression_parser_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::InvalidVariableGivenToExpressionParserError do
  describe "#accept" do
    subject(:accept) { error.accept(visitor) }

    before do
      allow(visitor)
        .to receive(:visit_invalid_variable_given_to_expression_parser_error)
        .with(error)
        .and_return(visit_result)
    end

    let(:error) { described_class.new(".;'") }
    let(:visitor) { double(:visitor) }
    let(:visit_result) { double(:visit_result) }

    it { is_expected.to eq(visit_result) }
  end
end
