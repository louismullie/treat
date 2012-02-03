module Treat
  module Extractors
    module Keywords
      class TfIdf
        DefaultOptions = { num_keywords: 5 }
        def self.keywords(entity, options = {})
          options = DefaultOptions.merge(options)
          tf_idfs = {}
          entity.each_word do |word|
            tf_idfs[word.value] ||= word.tf_idf
          end
          tf_idfs = tf_idfs.sort_by {|k,v| v}.reverse
          return tf_idfs if tf_idfs.size <= options[:num_keywords]
          keywords = []
          i = 0
          tf_idfs.each do |info|
            break if i > options[:num_keywords]
            keywords << info[0]
            i += 1
          end
          keywords
        end
      end
    end
  end
end