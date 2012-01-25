module Treat
  module Extractors
    module Statistics
      class Frequency
        # Find the frequency of the supplied entity
        # in its root parent.
        def self.statistics(entity, options={})
          if entity.is_leaf?
            w = entity.value.downcase
            if entity.token_registry[:value][w].nil?
              0
            else
              entity.token_registry[:value][w].size
            end
          else
            raise Treat::Exception,
            'Cannot get the frequency of a non-terminal entity.'
          end
        end
      end
    end
  end
end
