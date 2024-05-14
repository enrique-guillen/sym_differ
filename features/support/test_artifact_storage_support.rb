# frozen_string_literal: true

require "digest"
require "digest/bubblebabble"

module SymDiffer
  # Support for storing post-test artifacts that form part of the test suite's output but not printed as part of the
  # inmediate report (e.g., rspec logs).
  module TestArtifactStorageSupport
    def write_test_artifact_path(file_name, contents)
      file_path = test_artifact_path(file_name)
      hash_path = test_artifact_hash_path("#{file_name}.svg")

      File.write(file_path, contents)
      File.write(hash_path, ::Digest::SHA256.bubblebabble(contents))
    end

    private

    def test_artifact_path(file_name)
      directory = %w[features test_artifacts].join("/")
      [directory, file_name].join("/")
    end

    def test_artifact_hash_path(file_name)
      directory = %w[features test_artifact_hashes].join("/")
      [directory, file_name].join("/")
    end
  end
end

World(SymDiffer::TestArtifactStorageSupport)
