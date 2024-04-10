# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/empty_expression_text_error"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::EmptyExpressionTextError do
  describe ".new" do
    subject(:new) { described_class.new }

    it "does not raise an error" do
      expect { new }.not_to raise_error
    end
  end
end
