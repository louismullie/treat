module Treat
  module Extractors
    module Statistics
      class PositionIn
        # Find the position of the current entity
        # inside the parent entity with type entity_type.
        # Not implemented.
        def self.statistics(entity, options = {})
          raise Treat::Exception, 'Could you implement this?'
        end
      end
    end
  end
end