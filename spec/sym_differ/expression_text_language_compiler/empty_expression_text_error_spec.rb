# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/empty_expression_text_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::EmptyExpressionTextError do
  describe ".new" do
    subject(:new) { described_class.new }

    it "does not raise an error" do
      expect { new }.not_to raise_error
    end
  end
end
