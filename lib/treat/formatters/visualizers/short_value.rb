module Treat
  module Formatters
    module Visualizers
      class ShortValue
        def self.visualize(entity, options = {})
          options[:max_length] ||= 6
          words = entity.to_s.split(' ')
          return entity.to_s if words.size < options[:max_length]
          words[0..2].join(' ') + ' [...] ' + words[-3..-1].join(' ')
        end
      end
    end
  end
end
