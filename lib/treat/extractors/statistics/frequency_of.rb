module Treat
  module Extractors
    module Statistics
      class FrequencyOf
        # Find the frequency of a given string value.
        def self.statistics(entity, options = {})
          w = options[:value]
          raise Treat::Exception, "Must supply a non-nil value." unless w
          entity.token_registry[:value][w].nil? ? 0 :
          entity.token_registry[:value][w].size
        end
      end
    end
  end
end
