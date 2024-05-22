# frozen_string_literal: true

require "spec_helper"
require "sym_differ/first_order_differential_equation_approximation_illustration/builder"

require "sym_differ/stringifier_visitor"
require "sym_differ/svg_graphing/first_order_differential_equation_approximation_illustration_view_renderer"
require "sym_differ/expression_evaluator_visitor"

require "sym_differ/runge_kutta_four_solution_approximator"
require "sym_differ/first_order_differential_equation_solution/equation_parameters"

RSpec.describe SymDiffer::FirstOrderDifferentialEquationApproximationIllustration::Builder do
  describe "#build" do
    subject(:build) do
      described_class
        .new(expression_stringifier, view_renderer)
        .build(approximation_expression_path, equation_parameters)
    end

    let(:expression_factory) { sym_differ_expression_factory }
    let(:numerical_analysis_item_factory) { sym_differ_numerical_analysis_item_factory }

    let(:expression_stringifier) { SymDiffer::StringifierVisitor.new }

    let(:view_renderer) do
      SymDiffer::SvgGraphing::FirstOrderDifferentialEquationApproximationIllustrationViewRenderer.new
    end

    let(:approximation_expression_path) do
      SymDiffer::RungeKuttaFourSolutionApproximator
        .new(expression_evaluator_class.new, 0.125)
        .approximate_solution(equation_parameters, create_step_range(0.125..10.0))
    end

    let(:expression_evaluator_class) do
      Class.new do
        def evaluate(expression, variable_values)
          SymDiffer::ExpressionEvaluatorVisitor.new(variable_values).evaluate(expression)
        end
      end
    end

    context "when equation is y'=y, variable t, initial coordinates (0.0, 1.0)" do
      let(:equation_parameters) do
        SymDiffer::FirstOrderDifferentialEquationSolution::EquationParameters
          .new(variable_expression("y"), "y", "t", [0.0, 1.0])
      end

      it "can be stored in test artifacts after execution" do
        expect { build }.not_to raise_error

        write_test_artifact_path(
          prefix_with_class_name("build_dy_equals_y_at_0_0,0_0.svg"),
          build
        )
      end
    end

    context "when equation is y'=y, variable t, initial coordinates (0.0, 0.0)" do
      let(:equation_parameters) do
        SymDiffer::FirstOrderDifferentialEquationSolution::EquationParameters
          .new(constant_expression(0), "y", "t", [0.0, 0.0])
      end

      it "can be stored in test artifacts after execution" do
        expect { build }.not_to raise_error

        write_test_artifact_path(
          prefix_with_class_name("build_dy_equals_0_at_0_0,0_0.svg"),
          build
        )
      end
    end

    context "when equation is y'=1, variable t, initial coordinates (0.0, 0.0)" do
      let(:equation_parameters) do
        SymDiffer::FirstOrderDifferentialEquationSolution::EquationParameters
          .new(constant_expression(1), "y", "t", [0.0, 0.0])
      end

      it "can be stored in test artifacts after execution" do
        expect { build }.not_to raise_error

        write_test_artifact_path(
          prefix_with_class_name("build_dy_equals_1_at_0_0,0_0.svg"),
          build
        )
      end
    end

    define_method(:prefix_with_class_name) do |file_name|
      [filesystem_friendlify_class_name(described_class.name), file_name].join(".")
    end
  end
end
