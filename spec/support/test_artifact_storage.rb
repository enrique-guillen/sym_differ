# frozen_string_literal: true

module Support
  module TestArtifactStorage
    def write_test_artifact_path(file_name, contents)
      path = test_artifact_path(file_name)

      File.write(path, contents)
    end

    def filesystem_friendlify_class_name(class_name)
      class_name.split("::").join("_")
    end

    private

    def test_artifact_path(file_name)
      directory = %w[spec test_artifacts].join("/")
      [directory, file_name].join("/")
    end
  end
end
