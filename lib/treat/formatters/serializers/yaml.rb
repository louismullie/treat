module Treat
  module Formatters
    module Serializers
      # Require the Psych YAML serializer.
      require 'psych'
      # This class serializes entities in YAML format.
      class YAML
        # Serialize an entity in YAML format.
        def self.serialize(entity, options = {})
          ::Psych.dump(entity)
        end
      end
    end
  end
end
