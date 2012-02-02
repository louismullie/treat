module Treat
  module Formatters
    module Serializers
      # Require the Psych YAML serializer.
      require 'psych'
      # This class serializes entities in YAML format.
      class YAML
        # Serialize an entity in YAML format.
        #
        # Options:
        # - (String) :file => a file to write to.
        def self.serialize(entity, options = {})
          yaml = ::Psych.dump(entity)
          if options[:file]
            File.open(options[:file], 'w') { |f| f.write(yaml) }
          end
          yaml
        end
      end
    end
  end
end
