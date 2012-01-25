module Treat
  module Extractors
    module Statistics
      class FrequencyIn
        DefaultOptions = {type: nil}
        def self.statistics(entity, options={})
          options = DefaultOptions.merge(options)
          if entity.is_leaf?
            w = entity.value.downcase
            if entity.token_registry(options[:type])[:value][w].nil?
              0
            else
              entity.token_registry(options[:type])[:value][w].size
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
