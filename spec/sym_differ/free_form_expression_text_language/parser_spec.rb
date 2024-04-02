# frozen_string_literal: true

require "spec_helper"
require "sym_differ/free_form_expression_text_language/parser"

RSpec.describe SymDiffer::FreeFormExpressionTextLanguage::Parser do
  describe "#parse" do
    subject(:parse) do
      described_class.new.parse("x + x")
    end

    it "has the expected structure" do
      expression = parse

      expect(expression).to have_attributes(
        expression_a: an_object_having_attributes(name: "x"),
        expression_b: an_object_having_attributes(name: "x")
      )
    end
  end
end
