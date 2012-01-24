module Treat
  module Formatters
    module Unserializers
      class YAML
        # Require the Psych YAML parser.
        require 'psych'
        # Unserialize a YAML file representing an entity.
        def self.unserialize(document, options = {})
          document << ::Psych.load(File.read(document.file))
          document
        end
      end
    end
  end
end
