# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/unrecognized_token_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::UnrecognizedTokenError do
  describe ".new" do
    subject(:new) { described_class.new("x~") }

    it { is_expected.to have_attributes(invalid_expression_text: "x~") }
  end
end
