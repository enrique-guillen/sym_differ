# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/unrecognized_function_name_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::UnrecognizedFunctionNameError do
  describe ".new" do
    subject(:new) { described_class.new }

    it "does not raise an error" do
      expect { new }.not_to raise_error
    end
  end
end
