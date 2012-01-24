module Treat
  module Extractors
    module Statistics
      class FrequencyOf
        # Find the frequency of a given string value.
        def self.statistics(entity, options = {})
          w = options[:value]
          if entity.token_registry[:value][w].nil?
            0
          else
            entity.token_registry[:value][w].size
          end
        end
      end
    end
  end
end
