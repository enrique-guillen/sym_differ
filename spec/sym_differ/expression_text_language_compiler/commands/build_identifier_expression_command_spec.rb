# frozen_string_literal: true

require "spec_helper"
require "sym_differ/expression_text_language_compiler/commands/build_identifier_expression_command"

require "sym_differ/expression_text_language_compiler/unrecognized_function_name_error"

RSpec.describe SymDiffer::ExpressionTextLanguageCompiler::Commands::BuildIdentifierExpressionCommand do
  describe "#execute" do
    subject(:execute) { described_class.new(expression_factory, identifier_name).execute(arguments) }

    let(:expression_factory) { sym_differ_expression_factory }

    context "when identifier name = x, no arguments" do
      let(:identifier_name) { "x" }
      let(:arguments) { [] }

      it { is_expected.to be_same_as(variable_expression("x")) }
    end

    context "when identifier name = sine, one argument" do
      let(:identifier_name) { "sine" }
      let(:arguments) { [variable_expression("x")] }

      it { is_expected.to be_same_as(sine_expression(variable_expression("x"))) }
    end

    context "when identifier name = cosine, one argument" do
      let(:identifier_name) { "cosine" }
      let(:arguments) { [variable_expression("x")] }

      it { is_expected.to be_same_as(cosine_expression(variable_expression("x"))) }
    end

    context "when identifier name = ln, one argument" do
      let(:identifier_name) { "ln" }
      let(:arguments) { [variable_expression("x")] }

      it { is_expected.to be_same_as(natural_logarithm_expression(variable_expression("x"))) }
    end

    context "when identifier name = neverdefined, one argument" do
      let(:identifier_name) { "neverdefined" }
      let(:arguments) { [variable_expression("x")] }

      it "raises UnrecognizedFunctionNameError" do
        expect { execute }.to raise_error(SymDiffer::ExpressionTextLanguageCompiler::UnrecognizedFunctionNameError)
      end
    end
  end
end
