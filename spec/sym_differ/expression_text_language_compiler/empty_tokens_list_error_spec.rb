# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/empty_tokens_list_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::EmptyTokensListError do
  describe ".new" do
    subject(:new) { described_class.new }

    it { is_expected }
  end
end
