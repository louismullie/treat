module Treat::Extractors::Statistics
  class PositionInParent
    # Find the position of the current entity
    # inside the parent entity with type entity_type.
    # Not implemented.
    def self.statistics(entity, options = {})
      entity.parent.children.index(entity)      ## Fix - ancestor_w_type
    end
  end
end
