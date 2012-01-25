module Treat
  module Formatters
    module Unserializers
      # This class is a wrapper for the Psych YAML
      # parser; it unserializes YAML files.
      class YAML
        # Require the Psych YAML parser.
        require 'psych'
        # Unserialize a YAML file.
        def self.unserialize(document, options = {})
          document << ::Psych.load(File.read(document.file))
          document
        end
      end
    end
  end
end
