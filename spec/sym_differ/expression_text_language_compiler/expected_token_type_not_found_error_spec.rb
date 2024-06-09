# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/expected_token_type_not_found_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::ExpectedTokenTypeNotFoundError do
  describe ".new" do
    subject(:new) { described_class.new }

    it { is_expected }
  end
end
