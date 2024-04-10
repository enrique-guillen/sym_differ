# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/empty_expression_text_error"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::EmptyExpressionTextError do
  describe ".new" do
    subject(:new) do
      described_class.new("x~")
    end

    it { is_expected.to have_attributes(invalid_expression_text: "x~") }
  end
end
