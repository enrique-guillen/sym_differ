# frozen_string_literal: true

module SymDiffer
  module FirstOrderDifferentialEquationApproximationIllustration
    # Outputs information about the expression graphs that must be honored regardless of view size.
    class GraphParametersCalculator
      def calculate(approximation_expression_path)
        abscissa_parameters = extract_abscissas_parameters(approximation_expression_path)
        ordinate_parameters = extract_ordinate_parameters(approximation_expression_path)

        abscissa_parameters.merge(ordinate_parameters)
      end

      private

      def extract_ordinate_parameters(approximation_expression_path)
        ordinates = extract_ordinates(approximation_expression_path)
        max_ordinate_value = ordinates.max
        min_ordinate_value = ordinates.min
        ordinate_distance = max_ordinate_value - min_ordinate_value

        { max_ordinate_value:, min_ordinate_value:, ordinate_distance: }
      end

      def extract_abscissas_parameters(approximation_expression_path)
        abscissas = extract_abscissas(approximation_expression_path)
        max_abscissa_value = abscissas.max
        min_abscissa_value = abscissas.min
        abscissa_distance = max_abscissa_value - min_abscissa_value

        { max_abscissa_value:, min_abscissa_value:, abscissa_distance: }
      end

      def extract_ordinates(expression_path)
        expression_path.each.map(&:ordinate)
      end

      def extract_abscissas(expression_path)
        expression_path.each.map(&:abscissa)
      end
    end
  end
end
