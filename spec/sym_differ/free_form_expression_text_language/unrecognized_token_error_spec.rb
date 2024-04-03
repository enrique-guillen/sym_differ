# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/unrecognized_token_error"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::UnrecognizedTokenError do
  describe ".new" do
    subject(:new) { described_class.new("Unrecognized token encountered.", "x~") }

    it { is_expected.to have_attributes(message: "Unrecognized token encountered.", invalid_expression_text: "x~") }
  end
end
