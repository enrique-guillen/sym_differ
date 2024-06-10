# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/expected_token_type_not_found_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::ExpectedTokenTypeNotFoundError do
  describe ".new" do
    subject(:new) { described_class.new }

    it { is_expected }
  end

  describe "#accept" do
    subject(:accept) { error.accept(visitor) }

    before do
      allow(visitor)
        .to receive(:visit_expected_token_type_not_found_error)
        .with(error)
        .and_return(visit_result)
    end

    let(:error) { described_class.new }
    let(:visitor) { double(:visitor) }
    let(:visit_result) { double(:visit_result) }

    it { is_expected.to eq(visit_result) }
  end
end
