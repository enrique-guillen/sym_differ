# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "support/sym_differ_expression_double_builder"
require "support/sym_differ_expression_factory_dsl"
require "support/sym_differ_numerical_analysis_item_factory_dsl"
require "support/test_artifact_storage"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  (config.default_formatter = "doc") if config.files_to_run.one?

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.disable_monkey_patching!
  config.warnings = true
  config.order = :random

  Kernel.srand config.seed

  RSpec::Matchers.alias_matcher :same_expression_as, :be_same_as
  RSpec::Matchers.alias_matcher :same_evaluation_point_as, :be_same_as

  config.include Support::SymDifferDoubleBuilder
  config.include Support::SymDifferExpressionFactoryDsl
  config.include Support::SymDifferNumericalAnalysisItemFactoryDsl
  config.include Support::TestArtifactStorage
end
