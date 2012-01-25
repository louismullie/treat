module Treat
  module Extractors
    module Keywords
      class TopicsFrequency
        DefaultOptions = {tf_idf_threshold: 180, topic_words: nil}
        def self.keywords(entity, options = {})
          options = DefaultOptions.merge(options)
          unless options[:topic_words]
            raise Treat::Exception, "You must supply topic words."
          end
          if Treat::Entities.rank(entity.type) <
            Treat::Entities.rank(:sentence)
            raise Treat::Exception, 'Cannot get the key ' +
            'sentences of an entity smaller than a sentence.'
          else
            find_keywords(entity, options)
          end
        end
        def self.find_keywords(entity, options)
          keywords = []
          entity.each_word do |word|
            found = false
            options[:topic_words].each do |i, topic_words|
              next if keywords.include?(word.value)
              if topic_words.include?(word.value)
                found = true
                tf_idf = word.tf_idf
                if tf_idf < options[:tf_idf_threshold]
                  keywords << word.value
                  word.set :is_keyword?, found
                end
              end
            end
          end
          keywords
        end
      end
    end
  end
end