module Treat
  module Extractors
    module Statistics
      class FrequencyIn
        DefaultOptions = { :parent => nil }
        # Find the frequency of a given string value.
        def self.statistics(entity, options = {})
          options = DefaultOptions.merge(options)
          tr = entity.token_registry(options[:parent])
          tv = tr[:value][entity.value]
          tv ? tv.size : 1
        end
      end
    end
  end
end
