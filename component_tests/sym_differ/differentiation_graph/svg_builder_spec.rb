# frozen_string_literal: true

require "spec_helper"
require "sym_differ/differentiation_graph/svg_builder"

require "sym_differ/stringifier_visitor"

RSpec.describe SymDiffer::DifferentiationGraph::SvgBuilder do
  describe "#build" do
    subject(:build) do
      described_class
        .new(variable, expression_stringifier)
        .build(expression, derivative_expression)
    end

    let(:expression_factory) { sym_differ_expression_factory }

    let(:variable) { "x" }
    let(:expression_stringifier) { SymDiffer::StringifierVisitor.new }

    context "when the expression is 1" do
      let(:expression) { constant_expression(1) }
      let(:derivative_expression) { constant_expression(0) }

      it "can be stored in test artifacts after execution" do
        expect { build }.not_to raise_error

        write_test_artifact_path(
          prefix_with_class_name("build_constant_1_image.svg"),
          build
        )
      end
    end

    context "when the expression is 2" do
      let(:expression) { constant_expression(2) }
      let(:derivative_expression) { constant_expression(0) }

      it "can be stored in test artifacts after execution" do
        expect { build }.not_to raise_error

        write_test_artifact_path(
          prefix_with_class_name("build_constant_2_image.svg"),
          build
        )
      end
    end

    context "when the expression is 1.5" do
      let(:expression) { constant_expression(1.5) }
      let(:derivative_expression) { constant_expression(0) }

      it "can be stored in test artifacts after execution" do
        expect { build }.not_to raise_error

        write_test_artifact_path(
          prefix_with_class_name("build_constant_1dot5_image.svg"),
          build
        )
      end
    end

    context "when the expression is x" do
      let(:expression) { variable_expression("x") }
      let(:derivative_expression) { constant_expression(1) }

      it "can be stored in test artifacts after execution" do
        expect { build }.not_to raise_error

        write_test_artifact_path(
          prefix_with_class_name("build_x_image.svg"),
          build
        )
      end
    end

    context "when the expression is x * x" do
      let(:expression) { multiplicate_expression(variable_expression("x"), variable_expression("x")) }
      let(:derivative_expression) { sum_expression(variable_expression("x"), variable_expression("x")) }

      it "can be stored in test artifacts after execution" do
        expect { build }.not_to raise_error

        write_test_artifact_path(
          prefix_with_class_name("build_x_star_x_image.svg"),
          build
        )
      end
    end

    context "when the expression is sin(x * x)" do
      let(:expression) do
        sine_expression(
          multiplicate_expression(
            variable_expression("x"), variable_expression("x")
          )
        )
      end

      let(:derivative_expression) do
        multiplicate_expression(
          cosine_expression(
            multiplicate_expression(
              variable_expression("x"), variable_expression("x")
            )
          ),
          sum_expression(variable_expression("x"), variable_expression("x"))
        )
      end

      it "can be stored in test artifacts after execution" do
        expect { build }.not_to raise_error

        write_test_artifact_path(
          prefix_with_class_name("build_sine_x_star_x_image.svg"),
          build
        )
      end
    end

    context "when the expression is sin(x) - x" do
      let(:expression) do
        subtract_expression(
          sine_expression(variable_expression("x")),
          variable_expression("x")
        )
      end

      let(:derivative_expression) do
        subtract_expression(
          cosine_expression(variable_expression("x")),
          constant_expression(1)
        )
      end

      it "can be stored in test artifacts after execution" do
        expect { build }.not_to raise_error

        write_test_artifact_path(
          prefix_with_class_name("build_sine_x_minus_x_image.svg"),
          build
        )
      end
    end

    define_method(:write_test_artifact_path) do |file_name, contents|
      File.write(test_artifact_path(file_name), contents)
    end

    define_method(:prefix_with_class_name) do |file_name|
      [filesystem_friendlify_class_name(described_class.name), file_name].join(".")
    end

    define_method(:test_artifact_path) do |file_name|
      directory = %w[spec test_artifacts].join("/")
      [directory, file_name].join("/")
    end

    define_method(:filesystem_friendlify_class_name) do |class_name|
      class_name.split("::").join("_")
    end
  end
end
