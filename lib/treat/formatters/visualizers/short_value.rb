module Treat
  module Formatters
    module Visualizers
      class ShortValue
        # Default options for the visualizer.
        DefaultOptions = { :max_words => 6, :max_length => 30 }
        # Returns the text value of an entity, shortend
        # with [..] if the value is longer than :max_words
        # or longer than :max_length.
        #
        # Options:
        # - (Integer) :max_words => the maximum number
        # of words in an entity before it is shortened.
        # - (Integer) :max_length => the maximum number
        # of characters in an entity before it is shortened.s
        def self.visualize(entity, options = {})
          options = DefaultOptions.merge(options)
          words = entity.to_s.split(' ')
          if words.size < options[:max_words] || 
            entity.to_s.length < options[:max_length]
            entity.to_s
          else
            words[0..2].join(' ') + ' [...] ' + words[-3..-1].join(' ')
          end
        end
      end
    end
  end
end
