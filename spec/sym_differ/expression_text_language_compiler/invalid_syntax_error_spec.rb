# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/invalid_syntax_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::InvalidSyntaxError do
  describe ".new" do
    subject(:new) { described_class.new("x~") }

    it { is_expected.to have_attributes(invalid_expression_text: "x~") }
  end
end
