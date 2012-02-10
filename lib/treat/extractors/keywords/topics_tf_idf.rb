# Extract the N words from the LDA topics that have
# the highest TF*IDF and assign them as keywords.
class Treat::Extractors::Keywords::TopicsTfIdf

  # By default, retrieve five topics, consider
  # only words that have a TF*IDF > 50.
  DefaultOptions = {
    :num_keywords => 5,
    :tf_idf_threshold => 0.5
  }

  # Get the N best keywords scored by TF*IDF from
  # the supplied topic words or, by default, the 
  # topic words of the parent collection.
  def self.keywords(entity, options = {})
    options = DefaultOptions.merge(options)
    unless options[:topic_words]
      options[:topic_words] =
      entity.parent_collection.topic_words
    end
    find_keywords(entity, options)
  end

  # Helper method to find the keywords.
  def self.find_keywords(entity, options)
    keywords = []
    
    entity.each_word do |word|
      found = false
      tf_idf = word.tf_idf

      options[:topic_words].each do |topic_words|
        next if keywords.include?(word.value)
        if topic_words.include?(word.value)           # Need major fix here.
          found = true
          if tf_idf > options[:tf_idf_threshold]
            keywords << word.value
            word.set :is_keyword?, found
          end
        end
      end

    end

    i = 0
    # Take a slice of keywords with i elements.
    selected_keywords = []
    keywords.each do |keyword|
      break if i > options[:num_keywords]
      selected_keywords << keyword
      i += 1
    end

    selected_keywords
  end

end
