# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/imbalanced_expression_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::ImbalancedExpressionError do
  describe ".new" do
    subject(:new) { described_class.new }

    it { is_expected }
  end
end
